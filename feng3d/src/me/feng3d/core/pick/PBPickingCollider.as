package me.feng3d.core.pick
{
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.geom.Point;
	import flash.utils.ByteArray;

	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.core.math.Ray3D;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 基于PixelBender计算与实体的相交
	 */
	public class PBPickingCollider extends PickingColliderBase implements IPickingCollider
	{
		[Embed("../../../../../pb/RayTriangleKernel.pbj", mimeType = "application/octet-stream")]
		private var RayTriangleKernelClass:Class;

		/** 是否查找最短距离碰撞 */
		private var _findClosestCollision:Boolean;

		/** 射线与三角形相交检测渲染器 */
		private var _rayTriangleKernel:Shader;
		/** 最后被检测的几何体 */
		private var _lastSubMeshUploaded:SubMesh;
		/** 渲染器输出内容 */
		private var _kernelOutputBuffer:Vector.<Number>;

		/**
		 * 创建一个 PBPickingCollider
		 * @param findClosestCollision 是否查找最短距离碰撞
		 */
		public function PBPickingCollider(findClosestCollision:Boolean = false)
		{
			_findClosestCollision = findClosestCollision;

			//初始化出入缓存
			_kernelOutputBuffer = new Vector.<Number>();
			//初始化渲染器
			_rayTriangleKernel = new Shader(new RayTriangleKernelClass() as ByteArray);
		}

		override public function setLocalRay(ray3D:Ray3D):void
		{
			super.setLocalRay(ray3D);

			//上传射线信息到渲染器
			_rayTriangleKernel.data.rayStartPoint.value = [ray3D.position.x, ray3D.position.y, ray3D.position.z];
			_rayTriangleKernel.data.rayDirection.value = [ray3D.direction.x, ray3D.direction.y, ray3D.direction.z];
		}

		public function testSubMeshCollision(subMesh:SubMesh, pickingCollisionVO:PickingCollisionVO, shortestCollisionDistance:Number, bothSides:Boolean = true):Boolean
		{
			var subGeom:SubGeometry = subMesh.subGeometry;

			var cx:Number, cy:Number, cz:Number;
			var u:Number, v:Number, w:Number;
			var indexData:Vector.<uint> = subGeom.indexData;
			var vertexData:Vector.<Number> = subGeom.getVAData(Context3DBufferTypeID.POSITION_VA_3);
			var uvData:Vector.<Number> = subGeom.getVAData(Context3DBufferTypeID.UV_VA_2);
			var numericIndexData:Vector.<Number> = Vector.<Number>(indexData);
			var indexBufferDims:Point = evaluateArrayAsGrid(numericIndexData);

			//更新几何体数据到渲染器
			if (!_lastSubMeshUploaded || _lastSubMeshUploaded !== subMesh)
			{
				//上传顶点数据到pb
				var duplicateVertexData:Vector.<Number> = vertexData.concat();
				var vertexBufferDims:Point = evaluateArrayAsGrid(duplicateVertexData);
				_rayTriangleKernel.data.vertexBuffer.width = vertexBufferDims.x;
				_rayTriangleKernel.data.vertexBuffer.height = vertexBufferDims.y;
				_rayTriangleKernel.data.vertexBufferWidth.value = [vertexBufferDims.x];
				_rayTriangleKernel.data.vertexBuffer.input = duplicateVertexData;
				_rayTriangleKernel.data.bothSides.value = [bothSides ? 1.0 : 0.0];

				//上传索引数据到pb
				_rayTriangleKernel.data.indexBuffer.width = indexBufferDims.x;
				_rayTriangleKernel.data.indexBuffer.height = indexBufferDims.y;
				_rayTriangleKernel.data.indexBuffer.input = numericIndexData;
			}

			_lastSubMeshUploaded = subMesh;

			//运行渲染器(计算器)
			var shaderJob:ShaderJob = new ShaderJob(_rayTriangleKernel, _kernelOutputBuffer, indexBufferDims.x, indexBufferDims.y);
			shaderJob.start(true);

			//从输出数据中查找最优相交
			var i:uint;
			var t:Number;
			var collisionTriangleIndex:int = -1;
			var len:uint = _kernelOutputBuffer.length;
			for (i = 0; i < len; i += 3)
			{
				t = _kernelOutputBuffer[i];
				if (t > 0 && t < shortestCollisionDistance)
				{
					shortestCollisionDistance = t;
					collisionTriangleIndex = i;

					if (!_findClosestCollision)
						break;
				}
			}

			//检测冲突，收集数据
			if (collisionTriangleIndex >= 0)
			{
				pickingCollisionVO.rayEntryDistance = shortestCollisionDistance;

				pickingCollisionVO.localPosition = ray3D.getPoint(shortestCollisionDistance);

				pickingCollisionVO.localNormal = getCollisionNormal(indexData, vertexData, collisionTriangleIndex, pickingCollisionVO.localNormal);

				v = _kernelOutputBuffer[collisionTriangleIndex + 1]; // barycentric coord 1
				w = _kernelOutputBuffer[collisionTriangleIndex + 2]; // barycentric coord 2
				u = 1.0 - v - w;
				pickingCollisionVO.uv = getCollisionUV(indexData, uvData, collisionTriangleIndex, v, w, u, 0, 2, pickingCollisionVO.uv);
				pickingCollisionVO.index = collisionTriangleIndex * 3;
				return true;
			}

			return false;
		}

		/**
		 * 评估格子
		 * @param array
		 * @return
		 */
		private function evaluateArrayAsGrid(array:Vector.<Number>):Point
		{
			var count:uint = array.length / 3;
			var w:uint = Math.floor(Math.sqrt(count));
			var h:uint = w;
			var i:uint;
			while (w * h < count)
			{
				for (i = 0; i < w; ++i)
					array.push(0.0, 0.0, 0.0);
				h++;
			}
			return new Point(w, h);
		}
	}
}

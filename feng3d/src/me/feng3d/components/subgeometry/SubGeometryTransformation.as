package me.feng3d.components.subgeometry
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import me.feng.component.Component;
	import me.feng.component.event.ComponentEvent;
	import me.feng.component.event.vo.AddedComponentEventVO;
	import me.feng.component.event.vo.RemovedComponentEventVO;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.fagalRE.FagalIdCenter;

	/**
	 * 子几何体形变组件
	 * @author feng 2015-12-10
	 */
	public class SubGeometryTransformation extends Component
	{
		private var subGeometry:SubGeometry;

		private var _scaleU:Number = 1;
		private var _scaleV:Number = 1;

		public function SubGeometryTransformation()
		{
			super();

			addEventListener(ComponentEvent.BE_ADDED_COMPONET, onBeAddedComponet);
			addEventListener(ComponentEvent.BE_REMOVED_COMPONET, onBeRemovedComponet);
		}

		/**
		 * 处理被添加事件
		 * @param event
		 */
		protected function onBeAddedComponet(event:ComponentEvent):void
		{
			var addedComponentEventVO:AddedComponentEventVO = event.data;
			subGeometry = addedComponentEventVO.container as SubGeometry;
		}

		/**
		 * 处理被移除事件
		 * @param event
		 */
		protected function onBeRemovedComponet(event:ComponentEvent):void
		{
			var removedComponentEventVO:RemovedComponentEventVO = event.data;
			subGeometry = null;
		}


		public function get scaleU():Number
		{
			return _scaleU;
		}

		public function get scaleV():Number
		{
			return _scaleV;
		}

		public function scaleUV(scaleU:Number = 1, scaleV:Number = 1):void
		{
			var stride:int = subGeometry.getVALen(_.uv_va_2);
			var uvs:Vector.<Number> = subGeometry.UVData;
			var len:int = uvs.length;
			var ratioU:Number = scaleU / _scaleU;
			var ratioV:Number = scaleV / _scaleV;

			for (var i:uint = 0; i < len; i += stride)
			{
				uvs[i] *= ratioU;
				uvs[i + 1] *= ratioV;
			}

			_scaleU = scaleU;
			_scaleV = scaleV;

			subGeometry.setVAData(_.uv_va_2, uvs);
		}

		/**
		 * 缩放网格尺寸
		 */
		public function scale(scale:Number):void
		{
			var vertices:Vector.<Number> = subGeometry.getVAData(_.position_va_3);
			var len:uint = vertices.length;
			var stride:int = subGeometry.getVALen(_.position_va_3);

			for (var i:uint = 0; i < len; i += stride)
			{
				vertices[i] *= scale;
				vertices[i + 1] *= scale;
				vertices[i + 2] *= scale;
			}
			subGeometry.setVAData(_.position_va_3, vertices);
		}

		/**
		 * 应用变换矩阵
		 * @param transform 变换矩阵
		 */
		public function applyTransformation(transform:Matrix3D):void
		{
			var vertices:Vector.<Number> = subGeometry.vertexPositionData;
			var normals:Vector.<Number> = subGeometry.vertexNormalData;
			var tangents:Vector.<Number> = subGeometry.vertexTangentData;

			var posStride:int = subGeometry.vertexPositionStride;
			var normalStride:int = subGeometry.vertexNormalStride;
			var tangentStride:int = subGeometry.vertexTangentStride;

			var len:uint = vertices.length / posStride;
			var i:uint, i1:uint, i2:uint;
			var vector:Vector3D = new Vector3D();

			var bakeNormals:Boolean = normals != null;
			var bakeTangents:Boolean = tangents != null;
			var invTranspose:Matrix3D;

			if (bakeNormals || bakeTangents)
			{
				invTranspose = transform.clone();
				invTranspose.invert();
				invTranspose.transpose();
			}

			var vi0:int = 0;
			var ni0:int = 0;
			var ti0:int = 0;

			for (i = 0; i < len; ++i)
			{
				i1 = vi0 + 1;
				i2 = vi0 + 2;

				// bake position
				vector.x = vertices[vi0];
				vector.y = vertices[i1];
				vector.z = vertices[i2];
				vector = transform.transformVector(vector);
				vertices[vi0] = vector.x;
				vertices[i1] = vector.y;
				vertices[i2] = vector.z;
				vi0 += posStride;

				// bake normal
				if (bakeNormals)
				{
					i1 = ni0 + 1;
					i2 = ni0 + 2;
					vector.x = normals[ni0];
					vector.y = normals[i1];
					vector.z = normals[i2];
					vector = invTranspose.deltaTransformVector(vector);
					vector.normalize();
					normals[ni0] = vector.x;
					normals[i1] = vector.y;
					normals[i2] = vector.z;
					ni0 += normalStride;
				}

				// bake tangent
				if (bakeTangents)
				{
					i1 = ti0 + 1;
					i2 = ti0 + 2;
					vector.x = tangents[ti0];
					vector.y = tangents[i1];
					vector.z = tangents[i2];
					vector = invTranspose.deltaTransformVector(vector);
					vector.normalize();
					tangents[ti0] = vector.x;
					tangents[i1] = vector.y;
					tangents[i2] = vector.z;
					ti0 += tangentStride;
				}
			}

			subGeometry.setVAData(_.position_va_3, vertices);
			subGeometry.setVAData(_.normal_va_3, normals);
			subGeometry.setVAData(_.tangent_va_3, tangents);
		}

		/**
		 * Fagal编号中心
		 */
		public function get _():FagalIdCenter
		{
			return FagalIdCenter.instance;
		}
	}
}

package me.feng3d.core.pick
{
	import flash.geom.Point;
	import flash.geom.Vector3D;

	import me.feng3d.core.math.Ray3D;

	/**
	 *
	 * @author warden_feng 2014-4-30
	 */
	public class PickingColliderBase
	{
		protected var ray3D:Ray3D;

		public function PickingColliderBase()
		{
		}

		/**
		 * 获取碰撞法线
		 * @param indexData 顶点索引数据
		 * @param vertexData 顶点数据
		 * @param triangleIndex 三角形索引
		 * @param normal 碰撞法线
		 * @return 碰撞法线
		 *
		 */
		protected function getCollisionNormal(indexData:Vector.<uint>, vertexData:Vector.<Number>, triangleIndex:uint, normal:Vector3D = null):Vector3D
		{
			var i0:uint = indexData[triangleIndex] * 3;
			var i1:uint = indexData[triangleIndex + 1] * 3;
			var i2:uint = indexData[triangleIndex + 2] * 3;

			var side0x:Number = vertexData[i1] - vertexData[i0];
			var side0y:Number = vertexData[i1 + 1] - vertexData[i0 + 1];
			var side0z:Number = vertexData[i1 + 2] - vertexData[i0 + 2];
			var side1x:Number = vertexData[i2] - vertexData[i0];
			var side1y:Number = vertexData[i2 + 1] - vertexData[i0 + 1];
			var side1z:Number = vertexData[i2 + 2] - vertexData[i0 + 2];

			if (!normal)
				normal = new Vector3D();
			normal.x = side0y * side1z - side0z * side1y;
			normal.y = side0z * side1x - side0x * side1z;
			normal.z = side0x * side1y - side0y * side1x;
			normal.w = 1;
			normal.normalize();
			return normal;
		}

		/**
		 * 获取碰撞uv
		 * @param indexData 顶点数据
		 * @param uvData uv数据
		 * @param triangleIndex 三角形所有
		 * @param v
		 * @param w
		 * @param u
		 * @param uvOffset
		 * @param uvStride
		 * @param uv uv坐标
		 * @return 碰撞uv
		 */
		protected function getCollisionUV(indexData:Vector.<uint>, uvData:Vector.<Number>, triangleIndex:uint, v:Number, w:Number, u:Number, uvOffset:uint, uvStride:uint, uv:Point = null):Point
		{
			var uIndex:uint = indexData[triangleIndex] * uvStride + uvOffset;
			var uv0x:Number = uvData[uIndex];
			var uv0y:Number = uvData[uIndex + 1];
			uIndex = indexData[triangleIndex + 1] * uvStride + uvOffset;
			var uv1x:Number = uvData[uIndex];
			var uv1y:Number = uvData[uIndex + 1];
			uIndex = indexData[triangleIndex + 2] * uvStride + uvOffset;
			var uv2x:Number = uvData[uIndex];
			var uv2y:Number = uvData[uIndex + 1];
			if (!uv)
				uv = new Point();
			uv.x = u * uv0x + v * uv1x + w * uv2x;
			uv.y = u * uv0y + v * uv1y + w * uv2y;
			return uv;
		}

		/**
		 * 设置碰撞射线
		 */
		public function setLocalRay(ray3D:Ray3D):void
		{
			this.ray3D = ray3D;
		}
	}
}

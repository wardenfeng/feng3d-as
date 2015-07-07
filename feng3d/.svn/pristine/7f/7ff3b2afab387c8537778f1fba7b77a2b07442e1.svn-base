package me.feng3d.utils
{
	import flash.geom.Vector3D;

	/**
	 *
	 * @author warden_feng 2015-4-28
	 */
	public class ColliderUtils
	{
		public function ColliderUtils()
		{
		}

		/**
		 * 射线与三角形碰撞
		 * @param rayPosition		射线顶点
		 * @param rayDirection		射线方向
		 * @param p0				三角形顶点0
		 * @param p1				三角形顶点1
		 * @param p2				三角形顶点2
		 * @return					交点
		 */
		public static function rayTriangleCollision(rayPosition:Vector3D, rayDirection:Vector3D, p0:Vector3D, p1:Vector3D, p2:Vector3D):Vector3D
		{
			var t:Number;
			var rx:Number, ry:Number, rz:Number;
			var nx:Number, ny:Number, nz:Number;
			var cx:Number, cy:Number, cz:Number;
			var coeff:Number, u:Number, v:Number, w:Number;

			var p0x:Number, p0y:Number, p0z:Number;
			var p1x:Number, p1y:Number, p1z:Number;
			var p2x:Number, p2y:Number, p2z:Number;
			var s0x:Number, s0y:Number, s0z:Number;
			var s1x:Number, s1y:Number, s1z:Number;

			var nl:Number, nDotV:Number, D:Number, disToPlane:Number;
			var Q1Q2:Number, Q1Q1:Number, Q2Q2:Number, RQ1:Number, RQ2:Number;

			//三角形三个顶点数据
			p0x = p0.x;
			p0y = p0.y;
			p0z = p0.z;
			p1x = p1.x;
			p1y = p1.y;
			p1z = p1.z;
			p2x = p2.x;
			p2y = p2.y;
			p2z = p2.z;

			//计算出三角面的法线
			s0x = p1x - p0x; // s0 = p1 - p0
			s0y = p1y - p0y;
			s0z = p1z - p0z;
			s1x = p2x - p0x; // s1 = p2 - p0
			s1y = p2y - p0y;
			s1z = p2z - p0z;
			nx = s0y * s1z - s0z * s1y; // n = s0 x s1
			ny = s0z * s1x - s0x * s1z;
			nz = s0x * s1y - s0y * s1x;
			nl = 1 / Math.sqrt(nx * nx + ny * ny + nz * nz); // normalize n
			nx *= nl;
			ny *= nl;
			nz *= nl;

			//计算射线与法线的点积，小于零表示射线所在直线与三角面相交
			nDotV = nx * rayDirection.x + ny * +rayDirection.y + nz * rayDirection.z; // rayDirection . normal
			//判断射线所在直线是否与三角面相交
			if (nDotV != 0.0)
			{ // an intersection must exist
				//计算平面方程D值，参考Plane3D
				D = -(nx * p0x + ny * p0y + nz * p0z);
				//射线点到平面的距离
				disToPlane = -(nx * rayPosition.x + ny * rayPosition.y + nz * rayPosition.z + D);
				t = disToPlane / nDotV;
				//得到交点
				cx = rayPosition.x + t * rayDirection.x;
				cy = rayPosition.y + t * rayDirection.y;
				cz = rayPosition.z + t * rayDirection.z;
				//判断交点是否在三角形内( using barycentric coordinates )
				Q1Q2 = s0x * s1x + s0y * s1y + s0z * s1z;
				Q1Q1 = s0x * s0x + s0y * s0y + s0z * s0z;
				Q2Q2 = s1x * s1x + s1y * s1y + s1z * s1z;
				rx = cx - p0x;
				ry = cy - p0y;
				rz = cz - p0z;
				RQ1 = rx * s0x + ry * s0y + rz * s0z;
				RQ2 = rx * s1x + ry * s1y + rz * s1z;
				coeff = 1 / (Q1Q1 * Q2Q2 - Q1Q2 * Q1Q2);
				v = coeff * (Q2Q2 * RQ1 - Q1Q2 * RQ2);
				w = coeff * (-Q1Q2 * RQ1 + Q1Q1 * RQ2);
				if (v < 0)
					return null;
				if (w < 0)
					return null;
				u = 1 - v - w;
				//u v w都大于0表示点在三角形内 射线的坐标t大于0表示射线朝向三角面
				if (u >= 0 && t > 0)
				{
					return new Vector3D(cx, cy, cz)
				}
			}
			return null;
		}

	}
}

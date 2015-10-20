package me.feng3d.core.math
{
	import flash.geom.Vector3D;

	/**
	 * 三角形
	 * @author feng 2014-5-4
	 */
	public class Triangle3D
	{
		private var _p0:Vector3D;
		private var _p1:Vector3D;
		private var _p2:Vector3D;

		private var _normal:Vector3D;

		public function Triangle3D(p0:Vector3D, p1:Vector3D, p2:Vector3D)
		{
			this.p0 = p0;
			this.p1 = p1;
			this.p2 = p2;
		}

		/**
		 * 测试是否与直线相交
		 * @param line3D 直线
		 * @return 是否相交
		 */
		public function testLineCollision(line3D:Line3D):Boolean
		{
			return false;
		}

		/**
		 * 第1个点
		 */
		public function get p0():Vector3D
		{
			return _p0;
		}

		public function set p0(value:Vector3D):void
		{
			_p0 = value;
		}

		/**
		 * 第2个点
		 */
		public function get p1():Vector3D
		{
			return _p1;
		}

		public function set p1(value:Vector3D):void
		{
			_p1 = value;
		}

		/**
		 * 第3个点
		 */
		public function get p2():Vector3D
		{
			return _p2;
		}

		public function set p2(value:Vector3D):void
		{
			_p2 = value;
		}

		/**
		 * 法线
		 */
		public function get normal():Vector3D
		{
			if (_normal == null)
				updateNomal();
			return _normal;
		}

		private function updateNomal():void
		{
			_normal = p1.subtract(p0).crossProduct(p2.subtract(p0));
		}

	}
}

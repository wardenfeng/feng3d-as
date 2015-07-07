package me.feng3d.core.math
{
	import flash.geom.Vector3D;

	/**
	 * 3d直线
	 * @author warden_feng 2013-6-13
	 */
	public class Line3D
	{
		/** 直线上某一点 */
		public var position:Vector3D;

		/** 直线方向 */
		public var direction:Vector3D;

		/**
		 * 根据直线某点与方向创建直线
		 * @param position 直线上某点
		 * @param direction 直线的方向
		 */
		public function Line3D(position:Vector3D = null, direction:Vector3D = null)
		{
			this.position = position ? position : new Vector3D();
			this.direction = direction ? direction : new Vector3D(0, 0, 1);
		}

		/**
		 * 根据直线上两点初始化直线
		 * @param p0 Vector3D
		 * @param p1 Vector3D
		 */
		public function fromPoints(p0:Vector3D, p1:Vector3D):void
		{
			position = p0;
			direction = p1.subtract(p0);
		}

		/**
		 * 根据直线某点与方向初始化直线
		 * @param position 直线上某点
		 * @param direction 直线的方向
		 */
		public function fromPosAndDir(position:Vector3D, direction:Vector3D):void
		{
			this.position = position;
			this.direction = direction;
		}

		/**
		 * 获取直线上的一个点
		 * @param length 与原点距离
		 */
		public function getPoint(length:Number = 0):Vector3D
		{
			var lengthDir:Vector3D = direction.clone();
			lengthDir.scaleBy(length);
			var newPoint:Vector3D = position.add(lengthDir);
			return newPoint;
		}
	}
}

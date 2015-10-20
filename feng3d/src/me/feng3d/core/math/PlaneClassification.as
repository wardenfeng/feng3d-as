package me.feng3d.core.math
{

	/**
	 * 点与面的相对位置
	 * @author feng
	 */
	public class PlaneClassification
	{
		/**
		 * 在平面后面
		 * <p>等价于平面内</p>
		 * @see #IN
		 */
		public static const BACK:int = 0;
		/**
		 * 在平面前面
		 * <p>等价于平面外</p>
		 * @see #OUT
		 */
		public static const FRONT:int = 1;

		/**
		 * 在平面内
		 * <p>等价于在平面后</p>
		 * @see #BACK
		 */
		public static const IN:int = 0;
		/**
		 * 在平面外
		 * <p>等价于平面前面</p>
		 * @see #FRONT
		 */
		public static const OUT:int = 1;

		/**
		 * 与平面相交
		 */
		public static const INTERSECT:int = 2;
	}
}

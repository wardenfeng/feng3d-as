package me.feng3d.core.pick
{

	/**
	 * 定义检测相交的工具类
	 * @author feng 2014-4-30
	 */
	public class PickingColliderType
	{
		/**
		 * Default null collider that forces picker to only use entity bounds for hit calculations on an Entity
		 */
		public static const BOUNDS_ONLY:IPickingCollider = null;

		/**
		 * 基于PixelBender计算与实体的相交
		 */
		public static const PB_BEST_HIT:IPickingCollider = new PBPickingCollider(true);

		/**
		 * 使用纯AS3计算与实体相交
		 */
		public static const AS3_BEST_HIT:IPickingCollider = new AS3PickingCollider(true);

	}
}

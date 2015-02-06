package me.feng3d.core.pick
{
	
	/**
	 * 定义检测相交的工具类
	 * @author warden_feng 2014-4-30
	 */
	public class PickingColliderType
	{
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
package me.feng3d.materials.methods
{
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;

	/**
	 * 特效函数基类
	 * @author warden_feng 2015-8-27
	 */
	public class EffectMethodBase extends ShadingMethodBase implements IAsset
	{
		/**
		 * 创建特效函数基类实例
		 */
		public function EffectMethodBase()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		public function get assetType():String
		{
			return AssetType.EFFECTS_METHOD;
		}
	}
}

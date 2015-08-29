package me.feng3d.materials.methods
{
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;

	/**
	 *
	 * @author warden_feng 2015-8-27
	 */
	public class EffectMethodBase extends ShadingMethodBase implements IAsset
	{
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

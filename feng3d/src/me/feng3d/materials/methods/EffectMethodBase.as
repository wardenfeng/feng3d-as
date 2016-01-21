package me.feng3d.materials.methods
{
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.library.assets.NamedAsset;

	/**
	 * 特效函数基类
	 * @author feng 2015-8-27
	 */
	public class EffectMethodBase extends ShadingMethodBase implements IAsset
	{
		protected var _namedAsset:NamedAsset;
		/**
		 * 创建特效函数基类实例
		 */
		public function EffectMethodBase()
		{
			super();
			_namedAsset = new NamedAsset(this,AssetType.EFFECTS_METHOD);
		}
		
		public function get namedAsset():NamedAsset
		{
			return _namedAsset;
		}
		
	}
}

package me.feng3d.materials.lightpickers
{
	import me.feng.core.NamedAssetBase;
	import me.feng3d.arcane;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.lights.DirectionalLight;
	import me.feng3d.lights.LightBase;
	import me.feng3d.lights.PointLight;

	use namespace arcane;

	/**
	 * 灯光采集器
	 * @author warden_feng 2014-9-11
	 */
	public class LightPickerBase extends NamedAssetBase implements IAsset
	{
		protected var _numPointLights:uint;
		protected var _numDirectionalLights:uint;

		protected var _allPickedLights:Vector.<LightBase>;
		protected var _pointLights:Vector.<PointLight>;
		protected var _directionalLights:Vector.<DirectionalLight>;

		public function LightPickerBase()
		{
			super();
		}

		public function get assetType():String
		{
			return AssetType.LIGHT_PICKER;
		}

		/**
		 * 方向光数量
		 */
		public function get numDirectionalLights():uint
		{
			return _numDirectionalLights;
		}

		/**
		 * 点光源数量
		 */
		public function get numPointLights():uint
		{
			return _numPointLights;
		}

		/**
		 * 点光源列表
		 */
		public function get pointLights():Vector.<PointLight>
		{
			return _pointLights;
		}

		/**
		 * 方向光列表
		 */
		public function get directionalLights():Vector.<DirectionalLight>
		{
			return _directionalLights;
		}

		/**
		 * A collection of all the collected lights.
		 */
		public function get allPickedLights():Vector.<LightBase>
		{
			return _allPickedLights;
		}
	}
}

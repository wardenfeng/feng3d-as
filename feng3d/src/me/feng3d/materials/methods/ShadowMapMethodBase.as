package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsShadowMap;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.lights.LightBase;
	import me.feng3d.lights.shadowmaps.ShadowMapperBase;

	use namespace arcane;

	/**
	 * 阴影映射函数基类
	 * @author warden_feng 2015-5-28
	 */
	public class ShadowMapMethodBase extends ShadingMethodBase implements IAsset
	{
		protected var _castingLight:LightBase;
		protected var _shadowMapper:ShadowMapperBase;

		protected var _epsilon:Number = .02;
		protected var _alpha:Number = 1;

		/**
		 * 创建阴影映射函数基类
		 * @param castingLight		投射灯光
		 */
		public function ShadowMapMethodBase(castingLight:LightBase)
		{
			super();
			_castingLight = castingLight;
			castingLight.castsShadows = true;
			_shadowMapper = castingLight.shadowMapper;
		}

		/**
		 * 投射灯光
		 */
		public function get castingLight():LightBase
		{
			return _castingLight;
		}

		/**
		 * @inheritDoc
		 */
		public function get assetType():String
		{
			return AssetType.SHADOW_MAP_METHOD;
		}

		/**
		 * A small value to counter floating point precision errors when comparing values in the shadow map with the
		 * calculated depth value. Increase this if shadow banding occurs, decrease it if the shadow seems to be too detached.
		 */
		public function get epsilon():Number
		{
			return _epsilon;
		}

		public function set epsilon(value:Number):void
		{
			_epsilon = value;
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(shaderParams:ShaderParams):void
		{
			var shaderParamsShadowMap:ShaderParamsShadowMap = shaderParams.getComponent(ShaderParamsShadowMap.NAME);

			shaderParamsShadowMap.usingShadowMapMethod += 1;
			shaderParamsShadowMap.needsShadowRegister++;
		}
	}
}

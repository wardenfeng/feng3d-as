package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.lights.LightBase;
	import me.feng3d.lights.shadowmaps.ShadowMapperBase;

	use namespace arcane;

	/**
	 * 阴影映射函数基类
	 * @author feng 2015-5-28
	 */
	public class ShadowMapMethodBase extends ShadingMethodBase implements IAsset
	{
		public static const METHOD_TYPE:String = "ShadowMapMethod";

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
			methodType = METHOD_TYPE;
			typeUnique = true;
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
		 * The "transparency" of the shadows. This allows making shadows less strong.
		 */
		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			_alpha = value;
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
			shaderParams.usingShadowMapMethod += 1;
			shaderParams.needsShadowRegister++;
		}
	}
}

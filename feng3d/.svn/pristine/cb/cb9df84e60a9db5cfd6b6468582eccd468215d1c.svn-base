package me.feng3d.lights
{
	import me.feng.error.AbstractMethodError;
	import me.feng3d.arcane;
	import me.feng3d.entities.Entity;
	import me.feng3d.events.LightEvent;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.lights.shadowmaps.ShadowMapperBase;

	use namespace arcane;

	/**
	 * 灯光基类
	 * @author warden_feng 2014-9-11
	 */
	public class LightBase extends Entity
	{
		private var _color:uint = 0xffffff;
		private var _colorR:Number = 1;
		private var _colorG:Number = 1;
		private var _colorB:Number = 1;

		private var _ambientColor:uint = 0xffffff;
		private var _ambient:Number = 0;
		arcane var _ambientR:Number = 0;
		arcane var _ambientG:Number = 0;
		arcane var _ambientB:Number = 0;

		private var _specular:Number = 1;
		arcane var _specularR:Number = 1;
		arcane var _specularG:Number = 1;
		arcane var _specularB:Number = 1;

		private var _diffuse:Number = 1;
		arcane var _diffuseR:Number = 1;
		arcane var _diffuseG:Number = 1;
		arcane var _diffuseB:Number = 1;

		private var _castsShadows:Boolean;
		private var _shadowMapper:ShadowMapperBase;

		/**
		 * 创建一个灯光
		 */
		public function LightBase()
		{
			super();
		}

		public function get castsShadows():Boolean
		{
			return _castsShadows;
		}

		public function set castsShadows(value:Boolean):void
		{
			if (_castsShadows == value)
				return;

			_castsShadows = value;

			if (value)
			{
				_shadowMapper ||= createShadowMapper();
				_shadowMapper.light = this;
			}
			else
			{
				_shadowMapper.dispose();
				_shadowMapper = null;
			}

			dispatchEvent(new LightEvent(LightEvent.CASTS_SHADOW_CHANGE));
		}

		protected function createShadowMapper():ShadowMapperBase
		{
			throw new AbstractMethodError();
		}

		/**
		 * 灯光颜色。默认为<code>0xffffff</code>。
		 */
		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;
			_colorR = ((_color >> 16) & 0xff) / 0xff;
			_colorG = ((_color >> 8) & 0xff) / 0xff;
			_colorB = (_color & 0xff) / 0xff;
			updateDiffuse();
			updateSpecular();
		}

		/**
		 * 环境光强。默认为<code>0</code>。
		 */
		public function get ambient():Number
		{
			return _ambient;
		}

		public function set ambient(value:Number):void
		{
			if (value < 0)
				value = 0;
			else if (value > 1)
				value = 1;
			_ambient = value;
			updateAmbient();
		}

		/**
		 * 环境光颜色。默认为<code>0xffffff</code>。
		 */
		public function get ambientColor():uint
		{
			return _ambientColor;
		}

		public function set ambientColor(value:uint):void
		{
			_ambientColor = value;
			updateAmbient();
		}

		/**
		 * 漫反射光强。默认为<code>1</code>。
		 */
		public function get diffuse():Number
		{
			return _diffuse;
		}

		public function set diffuse(value:Number):void
		{
			if (value < 0)
				value = 0;
			_diffuse = value;
			updateDiffuse();
		}

		/**
		 * 镜面反射光强。默认为<code>1</code>。
		 */
		public function get specular():Number
		{
			return _specular;
		}

		public function set specular(value:Number):void
		{
			if (value < 0)
				value = 0;
			_specular = value;
			updateSpecular();
		}

		/**
		 * @inheritDoc
		 */
		override public function get assetType():String
		{
			return AssetType.LIGHT;
		}

		/**
		 * 更新镜面反射光成分
		 */
		private function updateSpecular():void
		{
			_specularR = _colorR * _specular;
			_specularG = _colorG * _specular;
			_specularB = _colorB * _specular;
		}

		/**
		 * 更新漫反射光成分
		 */
		private function updateDiffuse():void
		{
			_diffuseR = _colorR * _diffuse;
			_diffuseG = _colorG * _diffuse;
			_diffuseB = _colorB * _diffuse;
		}

		/**
		 * 更新环境光成分
		 */
		private function updateAmbient():void
		{
			_ambientR = ((_ambientColor >> 16) & 0xff) / 0xff * _ambient;
			_ambientG = ((_ambientColor >> 8) & 0xff) / 0xff * _ambient;
			_ambientB = (_ambientColor & 0xff) / 0xff * _ambient;
		}

		public function get shadowMapper():ShadowMapperBase
		{
			return _shadowMapper;
		}

		public function set shadowMapper(value:ShadowMapperBase):void
		{
			_shadowMapper = value;
			_shadowMapper.light = this;
		}
	}
}

package me.feng3d.lights
{
	import me.feng3d.arcane;
	import me.feng3d.entities.Entity;
	import me.feng3d.library.assets.AssetType;
	
	use namespace arcane;
	
	/**
	 * 光源
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
		
		public function LightBase()
		{
			super();
		}
		
		/**
		 * The color of the light. Default value is <code>0xffffff</code>.
		 */
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			_color = value;
			_colorR = ((_color >> 16) & 0xff)/0xff;
			_colorG = ((_color >> 8) & 0xff)/0xff;
			_colorB = (_color & 0xff)/0xff;
			updateDiffuse();
			updateSpecular();
		}
		
		/**
		 * The ambient emission strength of the light. Default value is <code>0</code>.
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
		 * The diffuse emission strength of the light. Default value is <code>1</code>.
		 */
		public function get diffuse():Number
		{
			return _diffuse;
		}
		
		public function set diffuse(value:Number):void
		{
			if (value < 0)
				value = 0;
			//else if (value > 1) value = 1;
			_diffuse = value;
			updateDiffuse();
		}
		
		/**
		 * The specular emission strength of the light. Default value is <code>1</code>.
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
		 * Updates the total specular components of the light.
		 */
		private function updateSpecular():void
		{
			_specularR = _colorR*_specular;
			_specularG = _colorG*_specular;
			_specularB = _colorB*_specular;
		}
		
		/**
		 * Updates the total diffuse components of the light.
		 */
		private function updateDiffuse():void
		{
			_diffuseR = _colorR*_diffuse;
			_diffuseG = _colorG*_diffuse;
			_diffuseB = _colorB*_diffuse;
		}
		
		private function updateAmbient():void
		{
			_ambientR = ((_ambientColor >> 16) & 0xff)/0xff*_ambient;
			_ambientG = ((_ambientColor >> 8) & 0xff)/0xff*_ambient;
			_ambientB = (_ambientColor & 0xff)/0xff*_ambient;
		}
	}
}
package me.feng3d.materials
{
	import flash.display.BlendMode;
	
	import me.feng3d.arcane;
	import me.feng3d.materials.lightpickers.LightPickerBase;
	import me.feng3d.materials.methods.BasicAmbientMethod;
	import me.feng3d.materials.methods.BasicDiffuseMethod;
	import me.feng3d.materials.methods.BasicSpecularMethod;
	import me.feng3d.passes.SuperShaderPass;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;
	
	/**
	 *
	 * @author warden_feng 2014-6-5
	 */
	public class SinglePassMaterialBase extends MaterialBase
	{
		protected var _screenPass:SuperShaderPass;
		private var _alphaBlending:Boolean;

		public function SinglePassMaterialBase()
		{
			super();
			addPass(_screenPass = new SuperShaderPass(this));
		}

		override public function set blendMode(value:String):void
		{
			super.blendMode = value;
			_screenPass.setBlendMode(blendMode == BlendMode.NORMAL && requiresBlending ? BlendMode.LAYER : blendMode);
		}

		override public function get requiresBlending():Boolean
		{
			return super.requiresBlending || _alphaBlending;
		}

		/**
		 * The colour of the ambient reflection.
		 */
		public function get ambientColor():uint
		{
			return _screenPass.ambientMethod.ambientColor;
		}
		
		public function set ambientColor(value:uint):void
		{
			_screenPass.ambientMethod.ambientColor = value;
		}

		/**
		 * The colour of the specular reflection.
		 */
		public function get specularColor():uint
		{
			return _screenPass.specularMethod.specularColor;
		}
		
		public function set specularColor(value:uint):void
		{
			_screenPass.specularMethod.specularColor = value;
		}

		/**
		 * The overall strength of the specular reflection.
		 */
		public function get specular():Number
		{
			return _screenPass.specularMethod? _screenPass.specularMethod.specular : 0;
		}
		
		public function set specular(value:Number):void
		{
			if (_screenPass.specularMethod)
				_screenPass.specularMethod.specular = value;
		}
		
		/**
		 * The strength of the ambient reflection.
		 */
		public function get ambient():Number
		{
			return _screenPass.ambientMethod.ambient;
		}
		
		public function set ambient(value:Number):void
		{
			_screenPass.ambientMethod.ambient = value;
		}
		
		/**
		 * The method that provides the diffuse lighting contribution. Defaults to BasicDiffuseMethod.
		 */
		public function get diffuseMethod():BasicDiffuseMethod
		{
			return _screenPass.diffuseMethod;
		}
		
		public function set diffuseMethod(value:BasicDiffuseMethod):void
		{
			_screenPass.diffuseMethod = value;
		}
		
		/**
		 * The method that provides the ambient lighting contribution. Defaults to BasicAmbientMethod.
		 */
		public function get ambientMethod():BasicAmbientMethod
		{
			return _screenPass.ambientMethod;
		}
		
		public function set ambientMethod(value:BasicAmbientMethod):void
		{
			_screenPass.ambientMethod = value;
		}
		
		/**
		 * The method that provides the specular lighting contribution. Defaults to BasicSpecularMethod.
		 */
		public function get specularMethod():BasicSpecularMethod
		{
			return _screenPass.specularMethod;
		}
		
		public function set specularMethod(value:BasicSpecularMethod):void
		{
			_screenPass.specularMethod = value;
		}
		
		/**
		 * The normal map to modulate the direction of the surface for each texel. The default normal method expects
		 * tangent-space normal maps, but others could expect object-space maps.
		 */
		public function get normalMap():Texture2DBase
		{
			return _screenPass.normalMap;
		}
		
		public function set normalMap(value:Texture2DBase):void
		{
			_screenPass.normalMap = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set lightPicker(value:LightPickerBase):void
		{
			super.lightPicker = value;
			_screenPass.lightPicker = value;
		}
	}
}

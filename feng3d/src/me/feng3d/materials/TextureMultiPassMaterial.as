package me.feng3d.materials
{
	import me.feng3d.materials.methods.BasicNormalMethod;
	import me.feng3d.materials.methods.BasicSpecularMethod;
	import me.feng3d.textures.Texture2DBase;
	
	
	/**
	 * 
	 * @author warden_feng 2014-5-19
	 */
	public class TextureMultiPassMaterial extends MultiPassMaterialBase
	{
		private var _ambientColor:uint = 0xffffff;
		private var _specularMethod:BasicSpecularMethod = new BasicSpecularMethod();
		private var _normalMethod:BasicNormalMethod = new BasicNormalMethod();
		
		public function TextureMultiPassMaterial(texture:Texture2DBase = null, smooth:Boolean = true, repeat:Boolean = false, mipmap:Boolean = true)
		{
			super();
			this.texture = texture;
		}

		public function get ambientColor():uint
		{
			return _ambientColor;
		}

		public function set ambientColor(value:uint):void
		{
			_ambientColor = value;
		}

		public function get specularMethod():BasicSpecularMethod
		{
			return _specularMethod;
		}

		public function set specularMethod(value:BasicSpecularMethod):void
		{
			_specularMethod = value;
		}

		/**
		 * The normal map to modulate the direction of the surface for each texel. The default normal method expects
		 * tangent-space normal maps, but others could expect object-space maps.
		 */
		public function get normalMap():Texture2DBase
		{
			return _normalMethod.normalMap;
		}
		
		public function set normalMap(value:Texture2DBase):void
		{
			_normalMethod.normalMap = value;
		}
		
		/**
		 * 高光贴图
		 * 
		 * A specular map that defines the strength of specular reflections for each texel in the red channel,
		 * and the gloss factor in the green channel. You can use SpecularBitmapTexture if you want to easily set
		 * specular and gloss maps from grayscale images, but correctly authored images are preferred.
		 */
		public function get specularMap():Texture2DBase
		{
			return _specularMethod.texture;
		}
		
		public function set specularMap(value:Texture2DBase):void
		{
			_specularMethod.texture = value;
		}
		
		/**
		 * The overall strength of the specular reflection.
		 */
		public function get specular():Number
		{
			return _specularMethod? _specularMethod.specular : 0;
		}
		
		public function set specular(value:Number):void
		{
			if (_specularMethod)
				_specularMethod.specular = value;
		}
		
	}
}
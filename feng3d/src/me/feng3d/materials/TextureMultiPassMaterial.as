package me.feng3d.materials
{
	import me.feng3d.materials.methods.BasicSpecularMethod;
	import me.feng3d.textures.Texture2DBase;
	
	
	/**
	 * 
	 * @author warden_feng 2014-5-19
	 */
	public class TextureMultiPassMaterial extends MultiPassMaterialBase
	{
		private var _ambientColor:uint = 0xffffff;
		private var _specularMethod:BasicSpecularMethod = new BasicSpecularMethod(null);
		
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


	}
}
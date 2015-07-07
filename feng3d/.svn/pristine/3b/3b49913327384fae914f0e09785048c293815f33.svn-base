package me.feng3d.materials
{
	import me.feng3d.arcane;
	import me.feng3d.materials.methods.BasicSpecularMethod;
	import me.feng3d.textures.BitmapTexture;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;
	
	/**
	 * 纹理材质
	 * @author warden_feng 2014-4-15
	 */
	public class TextureMaterial extends SinglePassMaterialBase
	{
		private var _alpha:Number;
		
		arcane var _specularMethod:BasicSpecularMethod;

		public function TextureMaterial(texture:BitmapTexture = null, smooth:Boolean = true, repeat:Boolean = false, mipmap:Boolean = true, bothSides:Boolean = true)
		{
			super();
			this.texture = texture;
			this.smooth = smooth;
			this.repeat = repeat;
			this.mipmap = mipmap;
			this.bothSides = bothSides;
		}

		public function get texture():Texture2DBase
		{
			return _screenPass.diffuseMethod.texture;
		}

		public function set texture(value:Texture2DBase):void
		{
			_screenPass.diffuseMethod.texture = value;
		}

		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			_alpha = value;
		}
	}
}

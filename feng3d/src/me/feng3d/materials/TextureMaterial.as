package me.feng3d.materials
{
	import me.feng3d.arcane;
	import me.feng3d.materials.methods.BasicSpecularMethod;
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

		/**
		 * 创建纹理材质
		 * @param texture		纹理
		 * @param smooth		是否平滑
		 * @param repeat		是否重复
		 * @param mipmap		是否使用mipmap
		 * @param bothSides		是否为双面
		 */
		public function TextureMaterial(texture:Texture2DBase = null, smooth:Boolean = true, repeat:Boolean = false, mipmap:Boolean = true, bothSides:Boolean = true)
		{
			super();
			this.texture = texture;
			this.smooth = smooth;
			this.repeat = repeat;
			this.mipmap = mipmap;
			this.bothSides = bothSides;
		}

		/**
		 * 纹理
		 */
		public function get texture():Texture2DBase
		{
			return _screenPass.diffuseMethod.texture;
		}

		public function set texture(value:Texture2DBase):void
		{
			_screenPass.diffuseMethod.texture = value;
		}

		/**
		 * 透明度
		 */
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

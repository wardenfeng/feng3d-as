package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.fagal.params.LightShaderParams;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;

	/**
	 * 基础法线函数
	 * @author feng 2014-7-16
	 */
	public class BasicNormalMethod extends ShadingMethodBase
	{
		public static const METHOD_TYPE:String = "NormalMethod";

		private var _texture:Texture2DBase;

		/**
		 * 创建一个基础法线函数
		 */
		public function BasicNormalMethod()
		{
			methodType = METHOD_TYPE;
			typeUnique = true;
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.normalTexture_fs, updateNormalTextureBuffer);
		}

		private function updateNormalTextureBuffer(normalTextureBuffer:FSBuffer):void
		{
			normalTextureBuffer.update(_texture);
		}

		/**
		 * The texture containing the normals per pixel.
		 */
		public function get normalMap():Texture2DBase
		{
			return _texture;
		}

		public function set normalMap(value:Texture2DBase):void
		{
			if (Boolean(value) != Boolean(_texture) || //
				(value && _texture && (value.hasMipMaps != _texture.hasMipMaps || value.format != _texture.format))) //
			{
				invalidateShaderProgram();
			}

			_texture = value;

			markBufferDirty(_.normalTexture_fs);
		}

		/**
		 * Indicates if the normal method output is not based on a texture (if not, it will usually always return true)
		 * Override if subclasses are different.
		 */
		arcane function get hasOutput():Boolean
		{
			return Boolean(_texture);
		}

		/**
		 * @inheritDoc
		 */
		override public function copyFrom(method:ShadingMethodBase):void
		{
			normalMap = BasicNormalMethod(method).normalMap;
		}

		override arcane function activate(shaderParams:ShaderParams):void
		{
			var lightShaderParams:LightShaderParams = shaderParams.getComponentByClass(LightShaderParams);

			lightShaderParams.hasNormalTexture = _texture != null;
			shaderParams.addSampleFlags(_.normalTexture_fs, _texture);
		}
	}
}

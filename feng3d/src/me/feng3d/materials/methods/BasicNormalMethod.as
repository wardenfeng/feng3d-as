package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.core.buffer.Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.core.proxy.Context3DCache;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.fagal.ShaderParams;
	import me.feng3d.passes.MaterialPassBase;
	import me.feng3d.textures.Texture2DBase;

	/**
	 *
	 * @author warden_feng 2014-7-16
	 */
	public class BasicNormalMethod extends ShadingMethodBase
	{
		private var _texture:Texture2DBase;

		/** 法线纹理数据缓冲 */
		protected var normalTextureBuffer:FSBuffer;

		public function BasicNormalMethod(pass:MaterialPassBase)
		{
			super(pass);
		}

		override protected function initBuffers():void
		{
			super.initBuffers();

			normalTextureBuffer = new FSBuffer(Context3DBufferTypeID.NORMALTEXTURE_FS, updateNormalTextureBuffer);
		}

		override public function collectCache(context3dCache:Context3DCache):void
		{
			super.collectCache(context3dCache);

			context3dCache.addDataBuffer(normalTextureBuffer);
		}

		override public function releaseCache(context3dCache:Context3DCache):void
		{
			super.releaseCache(context3dCache);

			context3dCache.removeDataBuffer(normalTextureBuffer);
		}

		private function updateNormalTextureBuffer():void
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

			normalTextureBuffer.invalid();
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

		override arcane function activate(shaderParams:ShaderParams, stage3DProxy:Stage3DProxy):void
		{
			shaderParams.hasNormalTexture = _texture;

			shaderParams.addSampleFlags(Context3DBufferTypeID.NORMALTEXTURE_FS, _texture);
		}
	}
}

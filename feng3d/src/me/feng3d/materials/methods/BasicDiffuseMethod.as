package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.core.buffer.Context3DBufferTypeID;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.core.proxy.Context3DCache;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.fagal.ShaderParams;
	import me.feng3d.fagal.fragment.light.F_DiffusePostLighting;
	import me.feng3d.passes.MaterialPassBase;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;

	/**
	 * 基础漫反射函数
	 * @author warden_feng 2014-7-1
	 */
	public class BasicDiffuseMethod extends LightingMethodBase
	{
		/** 片段程序的纹理数据缓冲 */
		protected var textureBuffer:FSBuffer;

		/** 漫射输入静态数据缓冲 */
		protected var diffuseInputBuffer:FCVectorBuffer;

		/** 漫反射纹理 */
		protected var _texture:Texture2DBase;

		private var _diffuseColor:uint = 0xffffff;

		/** 漫反射颜色数据RGBA */
		private var diffuseInputData:Vector.<Number> = new Vector.<Number>(4);

		/** 是否使用环境光材质 */
		private var _useAmbientTexture:Boolean;

		private var _isFirstLight:Boolean;

		public function BasicDiffuseMethod(pass:MaterialPassBase)
		{
			super(pass);
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			textureBuffer = new FSBuffer(Context3DBufferTypeID.TEXTURE_FS, updateTextureBuffer);
			diffuseInputBuffer = new FCVectorBuffer(Context3DBufferTypeID.DIFFUSEINPUT_FC_VECTOR, updateDiffuseInputBuffer);
		}

		override public function collectCache(context3dCache:Context3DCache):void
		{
			super.collectCache(context3dCache);

			context3dCache.addDataBuffer(textureBuffer);
			context3dCache.addDataBuffer(diffuseInputBuffer);
		}

		override public function releaseCache(context3dCache:Context3DCache):void
		{
			super.releaseCache(context3dCache);

			context3dCache.removeDataBuffer(textureBuffer);
			context3dCache.removeDataBuffer(diffuseInputBuffer);
		}

		/** 漫反射颜色 */
		public function get diffuseColor():uint
		{
			return _diffuseColor;
		}

		public function set diffuseColor(diffuseColor:uint):void
		{
			_diffuseColor = diffuseColor;
			updateDiffuse();
		}

		private function updateDiffuse():void
		{
			diffuseInputData[0] = ((_diffuseColor >> 16) & 0xff) / 0xff;
			diffuseInputData[1] = ((_diffuseColor >> 8) & 0xff) / 0xff;
			diffuseInputData[2] = (_diffuseColor & 0xff) / 0xff;
			diffuseInputBuffer.invalid();
		}

		/** 漫反射alpha */
		public function get diffuseAlpha():Number
		{
			return diffuseInputData[3];
		}

		public function set diffuseAlpha(value:Number):void
		{
			diffuseInputData[3] = value;
			diffuseInputBuffer.invalid();
		}

		private function updateTextureBuffer():void
		{
			textureBuffer.update(texture);
		}

		private function updateDiffuseInputBuffer():void
		{
			diffuseInputBuffer.update(diffuseInputData);
		}

		/**
		 * 漫反射纹理
		 */
		public function get texture():Texture2DBase
		{
			return _texture;
		}

		public function set texture(value:Texture2DBase):void
		{
			if (Boolean(value) != Boolean(_texture) || (value && _texture && (value.hasMipMaps != _texture.hasMipMaps || value.format != _texture.format)))
			{
				invalidateShaderProgram();
			}

			_texture = value;

			textureBuffer.invalid();
		}

		override arcane function activate(shaderParams:ShaderParams, stage3DProxy:Stage3DProxy):void
		{
			shaderParams.needsUV += texture ? 1 : 0;
			shaderParams.needsNormals += shaderParams.numLights > 0 ? 1 : 0;

			shaderParams.hasDiffuseTexture = _texture;
			shaderParams.usingDiffuseMethod += 1;
			
			shaderParams.diffuseMethod = F_DiffusePostLighting;

			shaderParams.addSampleFlags(Context3DBufferTypeID.TEXTURE_FS, _texture);
		}

		override public function copyFrom(method:ShadingMethodBase):void
		{
			var diff:BasicDiffuseMethod = BasicDiffuseMethod(method);
			texture = diff.texture;
			pass = diff.pass;
			diffuseAlpha = diff.diffuseAlpha;
			diffuseColor = diff.diffuseColor;
		}
	}
}

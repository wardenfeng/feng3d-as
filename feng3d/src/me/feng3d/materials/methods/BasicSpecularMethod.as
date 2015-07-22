package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsLight;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;

	/**
	 * 镜面反射方法
	 * @author warden_feng 2014-5-19
	 */
	public class BasicSpecularMethod extends LightingMethodBase
	{
		private var _gloss:int = 50;
		private var _specular:Number = 1;
		private var _specularColor:uint = 0xffffff;

		/** 镜面反射数据 */
		protected const _specularData:Vector.<Number> = new Vector.<Number>(4);

		private var _texture:Texture2DBase;

		public function BasicSpecularMethod()
		{
			super();
			updateSpecular();
		}

		/**
		 * 镜面反射颜色
		 */
		public function get specularColor():uint
		{
			return _specularColor;
		}

		public function set specularColor(value:uint):void
		{
			if (_specularColor == value)
				return;

			if (_specularColor == 0 || value == 0)
				invalidateShaderProgram();

			_specularColor = value;
			updateSpecular();
		}

		/**
		 * 镜面反射光泽图
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
			markBufferDirty(Context3DBufferTypeID.SPECULARTEXTURE_FS);
		}

		/**
		 * 镜面反射光反射强度
		 */
		public function get specular():Number
		{
			return _specular;
		}

		public function set specular(value:Number):void
		{
			if (value == _specular)
				return;

			_specular = value;
			updateSpecular();
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(Context3DBufferTypeID.SPECULARDATA_FC_VECTOR, updateSpecularDataBuffer);
			mapContext3DBuffer(Context3DBufferTypeID.SPECULARTEXTURE_FS, updateSpecularTextureBuffer);
		}

		private function updateSpecularDataBuffer(_specularDataBuffer:FCVectorBuffer):void
		{
			_specularDataBuffer.update(_specularData);
		}

		private function updateSpecularTextureBuffer(_specularTextureBuffer:FSBuffer):void
		{
			_specularTextureBuffer.update(_texture);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(shaderParams:ShaderParams):void
		{
			var shaderParamsLight:ShaderParamsLight = shaderParams.getComponent(ShaderParamsLight.NAME);

			shaderParams.needsUV += _texture != null ? 1 : 0;
			shaderParamsLight.needsNormals += shaderParamsLight.numLights > 0 ? 1 : 0;
			shaderParamsLight.needsViewDir += shaderParamsLight.numLights > 0 ? 1 : 0;

			shaderParamsLight.usingSpecularMethod += 1;
			shaderParamsLight.hasSpecularTexture = _texture != null;

			shaderParams.addSampleFlags(Context3DBufferTypeID.SPECULARTEXTURE_FS, _texture);
		}

		private function updateSpecular():void
		{
			_specularData[0] = ((_specularColor >> 16) & 0xff) / 0xff * _specular;
			_specularData[1] = ((_specularColor >> 8) & 0xff) / 0xff * _specular;
			_specularData[2] = (_specularColor & 0xff) / 0xff * _specular;
			_specularData[3] = _gloss;
		}
	}
}

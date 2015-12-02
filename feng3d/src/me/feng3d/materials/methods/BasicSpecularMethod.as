package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.fagal.fragment.light.SpecularModelType;
	import me.feng3d.fagal.params.CommonShaderParams;
	import me.feng3d.fagal.params.LightShaderParams;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;

	/**
	 * 镜面反射函数
	 * @author feng 2014-5-19
	 */
	public class BasicSpecularMethod extends LightingMethodBase
	{
		public static const METHOD_TYPE:String = "SpecularMethod";

		private var _gloss:int = 50;
		private var _specular:Number = 1;
		private var _specularColor:uint = 0xffffff;

		/** 镜面反射数据 */
		protected const _specularData:Vector.<Number> = Vector.<Number>([1, 1, 1, 50]);

		private var _texture:Texture2DBase;

		/**
		 * 创建镜面反射函数
		 */
		public function BasicSpecularMethod()
		{
			methodType = METHOD_TYPE;
			typeUnique = true;
			super();
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
			markBufferDirty(_.specularTexture_fs);
		}

		/**
		 * The sharpness of the specular highlight.
		 */
		public function get gloss():Number
		{
			return _gloss;
		}

		public function set gloss(value:Number):void
		{
			_gloss = value;
			updateSpecular();
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
			mapContext3DBuffer(_.specularData_fc_vector, updateSpecularDataBuffer);
			mapContext3DBuffer(_.specularTexture_fs, updateSpecularTextureBuffer);
		}

		private function updateSpecularDataBuffer(_specularDataBuffer:FCVectorBuffer):void
		{
			_specularDataBuffer.update(_specularData);
		}

		private function updateSpecularTextureBuffer(_specularTextureBuffer:FSBuffer):void
		{
			_specularTextureBuffer.update(texture);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(shaderParams:ShaderParams):void
		{
			var lightShaderParams:LightShaderParams = shaderParams.getComponentByClass(LightShaderParams);

			lightShaderParams.needsNormals += lightShaderParams.numLights > 0 ? 1 : 0;
			lightShaderParams.needsViewDir += lightShaderParams.numLights > 0 ? 1 : 0;
			lightShaderParams.usingSpecularMethod += 1;

			if (texture != null)
			{
				lightShaderParams.hasSpecularTexture++;

				var commonShaderParams:CommonShaderParams = shaderParams.getComponentByClass(CommonShaderParams);
				commonShaderParams.needsUV++
				shaderParams.addSampleFlags(_.specularTexture_fs, texture);
			}

			shaderParams.modulateMethod = _modulateMethod;
			shaderParams.specularModelType = SpecularModelType.BLINN_PHONG;
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

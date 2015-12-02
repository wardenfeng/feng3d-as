package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.fagal.fragment.light.F_DiffusePostLighting;
	import me.feng3d.fagal.params.CommonShaderParams;
	import me.feng3d.fagal.params.LightShaderParams;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;

	/**
	 * 基础漫反射函数
	 * @author feng 2014-7-1
	 */
	public class BasicDiffuseMethod extends LightingMethodBase
	{
		public static const METHOD_TYPE:String = "DiffuseMethod";

		/** 漫反射纹理 */
		protected var _texture:Texture2DBase;

		private var _diffuseColor:uint = 0xffffff;

		/** 漫反射颜色数据RGBA */
		private const diffuseInputData:Vector.<Number> = new Vector.<Number>(4);

		private const alphaThresholdData:Vector.<Number> = Vector.<Number>([0, 0, 0, 0]);

		/** 是否使用环境光材质 */
		private var _useAmbientTexture:Boolean;

		protected var _alphaThreshold:Number = 0;

		/**
		 * 创建一个基础漫反射函数
		 */
		public function BasicDiffuseMethod()
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
			mapContext3DBuffer(_.texture_fs, updateTextureBuffer);
			mapContext3DBuffer(_.diffuseInput_fc_vector, updateDiffuseInputBuffer);
			mapContext3DBuffer(_.alphaThreshold_fc_vector, updateAlphaThresholdBuffer);
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

		/**
		 * 更新漫反射值
		 */
		private function updateDiffuse():void
		{
			diffuseInputData[0] = ((_diffuseColor >> 16) & 0xff) / 0xff;
			diffuseInputData[1] = ((_diffuseColor >> 8) & 0xff) / 0xff;
			diffuseInputData[2] = (_diffuseColor & 0xff) / 0xff;
		}

		/** 漫反射alpha */
		public function get diffuseAlpha():Number
		{
			return diffuseInputData[3];
		}

		public function set diffuseAlpha(value:Number):void
		{
			diffuseInputData[3] = value;
		}

		/**
		 * 更新纹理缓冲
		 */
		private function updateTextureBuffer(textureBuffer:FSBuffer):void
		{
			textureBuffer.update(texture);
		}

		/**
		 * 更新漫反射输入片段常量缓冲
		 */
		private function updateDiffuseInputBuffer(diffuseInputBuffer:FCVectorBuffer):void
		{
			diffuseInputBuffer.update(diffuseInputData);
		}

		private function updateAlphaThresholdBuffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(alphaThresholdData);
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

			markBufferDirty(_.texture_fs);
		}

		/**
		 * The minimum alpha value for which pixels should be drawn. This is used for transparency that is either
		 * invisible or entirely opaque, often used with textures for foliage, etc.
		 * Recommended values are 0 to disable alpha, or 0.5 to create smooth edges. Default value is 0 (disabled).
		 */
		public function get alphaThreshold():Number
		{
			return _alphaThreshold;
		}

		public function set alphaThreshold(value:Number):void
		{
			if (value < 0)
				value = 0;
			else if (value > 1)
				value = 1;
			if (value == _alphaThreshold)
				return;

			if (value == 0 || _alphaThreshold == 0)
				invalidateShaderProgram();

			_alphaThreshold = value;

			alphaThresholdData[0] = _alphaThreshold;
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(shaderParams:ShaderParams):void
		{
			var commonShaderParams:CommonShaderParams = shaderParams.getComponent(CommonShaderParams.NAME);

			if (texture != null)
			{
				commonShaderParams.needsUV++;
				commonShaderParams.hasDiffuseTexture++;
				shaderParams.addSampleFlags(_.texture_fs, texture);
			}

			commonShaderParams.usingDiffuseMethod += 1;
			commonShaderParams.alphaThreshold = _alphaThreshold;

			shaderParams.diffuseModulateMethod = _modulateMethod;

			var lightShaderParams:LightShaderParams = shaderParams.getComponent(LightShaderParams.NAME);
			lightShaderParams.needsNormals += lightShaderParams.numLights > 0 ? 1 : 0;
			lightShaderParams.diffuseMethod = F_DiffusePostLighting;
		}

		/**
		 * @inheritDoc
		 */
		override public function copyFrom(method:ShadingMethodBase):void
		{
			var diff:BasicDiffuseMethod = BasicDiffuseMethod(method);
			texture = diff.texture;
			diffuseAlpha = diff.diffuseAlpha;
			diffuseColor = diff.diffuseColor;
		}
	}
}

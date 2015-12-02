package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.fagal.params.CommonShaderParams;
	import me.feng3d.fagal.params.EnvShaderParams;
	import me.feng3d.fagal.params.LightShaderParams;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.textures.CubeTextureBase;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;

	/**
	 * 环境映射函数
	 * @author feng 2015-8-27
	 */
	public class EnvMapMethod extends EffectMethodBase
	{
		private const _envMapData:Vector.<Number> = Vector.<Number>([1, 0, 0, 0]);

		private var _cubeTexture:CubeTextureBase;
		private var _alpha:Number;
		private var _mask:Texture2DBase;

		/**
		 * 创建EnvMapMethod实例
		 * @param envMap		环境映射贴图
		 * @param alpha			反射率
		 */
		public function EnvMapMethod(envMap:CubeTextureBase, alpha:Number = 1)
		{
			super();
			_cubeTexture = envMap;
			this.alpha = alpha;
		}

		/**
		 * 用来调节反射率的纹理
		 */
		public function get mask():Texture2DBase
		{
			return _mask;
		}

		public function set mask(value:Texture2DBase):void
		{
			if (Boolean(value) != Boolean(_mask) || (value && _mask && (value.hasMipMaps != _mask.hasMipMaps || value.format != _mask.format)))
			{
				invalidateShaderProgram();
			}
			_mask = value;

			markBufferDirty(_.envMapMaskTexture_fs);
		}

		/**
		 * 环境映射贴图
		 */
		public function get envMap():CubeTextureBase
		{
			return _cubeTexture;
		}

		public function set envMap(value:CubeTextureBase):void
		{
			_cubeTexture = value;

			markBufferDirty(_.envMapcubeTexture_fs);
		}

		/**
		 * 反射率
		 */
		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			_alpha = value;
			_envMapData[0] = _alpha;
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.envMapcubeTexture_fs, updateCubeTextureBuffer);
			mapContext3DBuffer(_.envMapMaskTexture_fs, updateMaskTextureBuffer);
			mapContext3DBuffer(_.envMapData_fc_vector, updateDataBuffer);
		}

		private function updateCubeTextureBuffer(fsBuffer:FSBuffer):void
		{
			fsBuffer.update(_cubeTexture);
		}

		private function updateMaskTextureBuffer(fsBuffer:FSBuffer):void
		{
			fsBuffer.update(_mask);
		}

		private function updateDataBuffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(_envMapData);
		}

		/**
		 * @inheritDoc
		 */
		arcane override function activate(shaderParams:ShaderParams):void
		{
			var commonShaderParams:CommonShaderParams = shaderParams.getComponentByClass(CommonShaderParams);
			commonShaderParams.needsUV += _mask != null;

			var lightShaderParams:LightShaderParams = shaderParams.getComponentByClass(LightShaderParams);
			lightShaderParams.needsNormals++;
			lightShaderParams.needsViewDir++;

//			shaderParams.needsView = true;

			var envShaderParams:EnvShaderParams = shaderParams.getComponentByClass(EnvShaderParams);
			envShaderParams.useEnvMapMethod++;
			envShaderParams.useEnvMapMask += _mask != null;

			shaderParams.addSampleFlags(_.envMapcubeTexture_fs, _cubeTexture);
			shaderParams.addSampleFlags(_.envMapMaskTexture_fs, _mask);

//			var context:Context3D = stage3DProxy._context3D;
//			vo.fragmentData[vo.fragmentConstantsIndex] = _alpha;
//			context.setTextureAt(vo.texturesIndex, _cubeTexture.getTextureForStage3D(stage3DProxy));
//			if (_mask)
//				context.setTextureAt(vo.texturesIndex + 1, _mask.getTextureForStage3D(stage3DProxy));
		}
	}
}

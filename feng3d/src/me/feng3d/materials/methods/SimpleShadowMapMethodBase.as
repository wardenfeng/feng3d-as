package me.feng3d.materials.methods
{
	import flash.display3D.Context3DTextureFilter;
	import flash.display3D.Context3DWrapMode;
	import flash.geom.Matrix3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShadowShaderParams;
	import me.feng3d.lights.LightBase;
	import me.feng3d.lights.PointLight;
	import me.feng3d.lights.shadowmaps.DirectionalShadowMapper;

	use namespace arcane;

	/**
	 * 简单阴影映射函数基类
	 * @author feng 2015-5-28
	 */
	public class SimpleShadowMapMethodBase extends ShadowMapMethodBase
	{
		/**
		 * 是否使用点光源
		 */
		protected var _usePoint:Boolean;

		/**
		 * 顶点常量数据0
		 */
		protected var shadowCommonsVCData0:Vector.<Number> = Vector.<Number>([0.5, -0.5, 0.0, 1.0]);

		/**
		 * 通用数据0
		 */
		protected var shadowCommonsData0:Vector.<Number> = Vector.<Number>([1.0, 1 / 255.0, 1 / 65025.0, 1 / 16581375.0]);

		/**
		 * 通用数据1
		 */
		protected var shadowCommonsData1:Vector.<Number> = Vector.<Number>([0, 0, 0, 1]);

		/**
		 * 通用数据2
		 */
		protected var shadowCommonsData2:Vector.<Number> = Vector.<Number>([0.5, 2048, 1.0 / 2048, 0]);

		/**
		 * 深度投影矩阵
		 */
		protected var depthProjection:Matrix3D = new Matrix3D();

		/**
		 * 创建简单阴影映射方法基类
		 * @param castingLight			投射阴影的灯光
		 */
		public function SimpleShadowMapMethodBase(castingLight:LightBase)
		{
			_usePoint = castingLight is PointLight;

			super(castingLight);
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.shadowCommondata0_vc_vector, updateShadowCommonVCData0Buffer);
			mapContext3DBuffer(_.shadowCommondata0_fc_vector, updateShadowCommonData0Buffer);
			mapContext3DBuffer(_.shadowCommondata1_fc_vector, updateShadowCommonData1Buffer);
			mapContext3DBuffer(_.shadowCommondata2_fc_vector, updateShadowCommonData2Buffer);
			mapContext3DBuffer(_.depthMap_vc_matrix, updateDepthProjectionMatrixBuffer);

			mapContext3DBuffer(_.depthMap_fs, updateTextureBuffer);
		}

		protected function updateShadowCommonVCData0Buffer(vcVectorBuffer:VCVectorBuffer):void
		{
			vcVectorBuffer.update(shadowCommonsVCData0);
		}

		protected function updateShadowCommonData0Buffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(shadowCommonsData0);
		}

		protected function updateShadowCommonData1Buffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(shadowCommonsData1);
		}

		protected function updateShadowCommonData2Buffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(shadowCommonsData2);
		}

		/**
		 * 更新深度投影矩阵缓冲
		 * @param sceneTransformMatrixBuffer		场景变换矩阵缓冲
		 */
		protected function updateDepthProjectionMatrixBuffer(sceneTransformMatrixBuffer:VCMatrixBuffer):void
		{
			sceneTransformMatrixBuffer.update(depthProjection, true);
		}

		/**
		 * 更新深度图纹理缓冲
		 */
		private function updateTextureBuffer(textureBuffer:FSBuffer):void
		{
			textureBuffer.update(_castingLight.shadowMapper.depthMap);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(shaderParams:ShaderParams):void
		{
			super.activate(shaderParams);

			var shadowShaderParams:ShadowShaderParams = shaderParams.getComponent(ShadowShaderParams.NAME);
			shadowShaderParams.usePoint += _usePoint;

			if (_usePoint)
				shadowCommonsData1[0] = -Math.pow(1 / ((_castingLight as PointLight).fallOff * _epsilon), 2);
			else
				shadowCommonsVCData0[3] = -1 / (DirectionalShadowMapper(_shadowMapper).depth * _epsilon);

			shadowCommonsData1[1] = 1 - _alpha;

			var size:int = castingLight.shadowMapper.depthMapSize;
			shadowCommonsData2[1] = size;
			shadowCommonsData2[2] = 1 / size;

			//通用渲染参数
			var flags:Array = [castingLight.shadowMapper.depthMap.type, Context3DTextureFilter.NEAREST, Context3DWrapMode.CLAMP];
			shaderParams.setSampleFlags(_.depthMap_fs, flags);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{
			if (!_usePoint)
			{
				depthProjection.copyFrom(DirectionalShadowMapper(_shadowMapper).depthProjection);
			}
		}

	}
}

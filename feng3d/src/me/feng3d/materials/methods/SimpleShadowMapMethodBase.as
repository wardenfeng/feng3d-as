package me.feng3d.materials.methods
{
	import flash.geom.Matrix3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.fagal.TextureFlag;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDShadow;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsCommon;
	import me.feng3d.fagal.params.ShaderParamsShadowMap;
	import me.feng3d.lights.LightBase;
	import me.feng3d.lights.PointLight;
	import me.feng3d.lights.shadowmaps.DirectionalShadowMapper;

	use namespace arcane;

	/**
	 *
	 * @author warden_feng 2015-5-28
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
		protected var shadowCommonsVCData0:Vector.<Number> = new Vector.<Number>(4);

		/**
		 * 通用数据0
		 */
		protected var shadowCommonsData0:Vector.<Number> = new Vector.<Number>(4);

		/**
		 * 通用数据1
		 */
		protected var shadowCommonsData1:Vector.<Number> = new Vector.<Number>(4);

		/**
		 * 通用数据2
		 */
		protected var shadowCommonsData2:Vector.<Number> = new Vector.<Number>(4);

		/**
		 * 深度投影矩阵
		 */
		protected var depthProjection:Matrix3D = new Matrix3D();

		public function SimpleShadowMapMethodBase(castingLight:LightBase)
		{
			_usePoint = castingLight is PointLight;

			super(castingLight);
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(Context3DBufferTypeIDShadow.SHADOWCOMMONDATA0_VC_VECTOR, VCVectorBuffer, updateShadowCommonVCData0Buffer);
			mapContext3DBuffer(Context3DBufferTypeIDShadow.SHADOWCOMMONDATA0_FC_VECTOR, FCVectorBuffer, updateShadowCommonData0Buffer);
			mapContext3DBuffer(Context3DBufferTypeIDShadow.SHADOWCOMMONDATA1_FC_VECTOR, FCVectorBuffer, updateShadowCommonData1Buffer);
			mapContext3DBuffer(Context3DBufferTypeIDShadow.SHADOWCOMMONDATA2_FC_VECTOR, FCVectorBuffer, updateShadowCommonData2Buffer);
			mapContext3DBuffer(Context3DBufferTypeIDShadow.DEPTHMAP_VC_MATRIX, VCMatrixBuffer, updateDepthProjectionMatrixBuffer);

			mapContext3DBuffer(Context3DBufferTypeIDShadow.DEPTHMAP_FS, FSBuffer, updateTextureBuffer);
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

		private function updateTextureBuffer(textureBuffer:FSBuffer):void
		{
			textureBuffer.update(_castingLight.shadowMapper.depthMap);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function initConstants():void
		{
			shadowCommonsData0[0] = 1.0;
			shadowCommonsData0[1] = 1 / 255.0;
			shadowCommonsData0[2] = 1 / 65025.0;
			shadowCommonsData0[3] = 1 / 16581375.0;

			shadowCommonsData1[2] = 0;
			shadowCommonsData1[3] = 1;

			shadowCommonsData2[0] = 0.5;
			var size:int = castingLight.shadowMapper.depthMapSize;
			shadowCommonsData2[1] = size;
			shadowCommonsData2[2] = 1 / size;

			shadowCommonsVCData0[0] = .5;
			shadowCommonsVCData0[1] = -.5;
			shadowCommonsVCData0[2] = 0.0;
			shadowCommonsVCData0[3] = 1.0;
		}

		override arcane function activate(shaderParams:ShaderParams):void
		{
			super.activate(shaderParams);

			var shaderParamsShadowMap:ShaderParamsShadowMap = shaderParams.getComponent(ShaderParamsShadowMap.NAME);

			shaderParamsShadowMap.usePoint = _usePoint;

			if (_usePoint)
				shadowCommonsData1[0] = -Math.pow(1 / ((_castingLight as PointLight).fallOff * _epsilon), 2);
			else
				shadowCommonsVCData0[3] = -1 / (DirectionalShadowMapper(_shadowMapper).depth * _epsilon);

			shadowCommonsData1[1] = 1 - _alpha;

			//通用渲染参数
			var common:ShaderParamsCommon = shaderParams.getComponent(ShaderParamsCommon.NAME);
			var flags:Array = [castingLight.shadowMapper.depthMap.type, TextureFlag.FILTER_NEAREST, TextureFlag.MODE_CLAMP];
			common.setSampleFlags(Context3DBufferTypeIDShadow.DEPTHMAP_FS, flags);
		}

		override arcane function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{
			if (!_usePoint)
			{
				depthProjection.copyFrom(DirectionalShadowMapper(_shadowMapper).depthProjection);
			}
		}

	}
}

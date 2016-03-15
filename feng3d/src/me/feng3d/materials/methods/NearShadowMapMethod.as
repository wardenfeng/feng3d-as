package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.events.ShadingMethodEvent;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShadowShaderParams;
	import me.feng3d.lights.shadowmaps.NearDirectionalShadowMapper;

	use namespace arcane;

	/**
	 * 近阴影映射函数
	 * @author feng 2015-5-28
	 */
	public class NearShadowMapMethod extends SimpleShadowMapMethodBase
	{
		private var secondaryFragmentConstants:Vector.<Number> = new Vector.<Number>(4);

		private var _baseMethod:SimpleShadowMapMethodBase;
		/**
		 * 阴影消退比例值
		 */
		private var _fadeRatio:Number;
		private var _nearShadowMapper:NearDirectionalShadowMapper;

		/**
		 * 创建近阴影映射函数
		 * @param baseMethod		基础映射函数
		 * @param fadeRatio			消退比率
		 */
		public function NearShadowMapMethod(baseMethod:SimpleShadowMapMethodBase, fadeRatio:Number = .1)
		{
			super(baseMethod.castingLight);
			_baseMethod = baseMethod;
			_fadeRatio = fadeRatio;
			_nearShadowMapper = _castingLight.shadowMapper as NearDirectionalShadowMapper;
			if (!_nearShadowMapper)
				throw new Error("NearShadowMapMethod requires a light that has a NearDirectionalShadowMapper instance assigned to shadowMapper.");
			_baseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
		}

		/**
		 * The base shadow map method on which this method's shading is based.
		 */
		public function get baseMethod():SimpleShadowMapMethodBase
		{
			return _baseMethod;
		}

		public function set baseMethod(value:SimpleShadowMapMethodBase):void
		{
			if (_baseMethod == value)
				return;
			_baseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
			_baseMethod = value;
			_baseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated, false, 0, true);
			invalidateShaderProgram();
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			context3DBufferOwner.mapContext3DBuffer(_.secondary_fc_vector, updateSecondaryCommonData0Buffer);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function initConstants():void
		{
			super.initConstants();

			_baseMethod.initConstants();

			secondaryFragmentConstants[0] = 0;
			secondaryFragmentConstants[1] = 0;
			secondaryFragmentConstants[2] = 0;
			secondaryFragmentConstants[3] = 1;
		}

		private function updateSecondaryCommonData0Buffer(fcVectorBuffer:FCVectorBuffer):void
		{
			fcVectorBuffer.update(secondaryFragmentConstants);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{
			var near:Number = camera.lens.near;
			var d:Number = camera.lens.far - near;
			var maxDistance:Number = _nearShadowMapper.coverageRatio;
			var minDistance:Number = maxDistance * (1 - _fadeRatio);

			maxDistance = near + maxDistance * d;
			minDistance = near + minDistance * d;

			secondaryFragmentConstants[0] = minDistance;
			secondaryFragmentConstants[1] = 1 / (maxDistance - minDistance);

			super.setRenderState(renderable, camera);
			_baseMethod.setRenderState(renderable, camera);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(shaderParams:ShaderParams):void
		{
			super.activate(shaderParams);

			var shadowShaderParams:ShadowShaderParams = shaderParams.getOrCreateComponentByClass(ShadowShaderParams);
			shadowShaderParams.needsProjection++;
			shadowShaderParams.useNearShadowMap++;
		}

		/**
		 * 处理渲染程序失效事件
		 */
		private function onShaderInvalidated(event:ShadingMethodEvent):void
		{
			invalidateShaderProgram();
		}
	}
}

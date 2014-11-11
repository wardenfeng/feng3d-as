package me.feng3d.animators
{
	import me.feng3d.arcane;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.fagal.ShaderParams;
	import me.feng3d.fagal.vertex.animation.V_VertexAnimationCPU;
	import me.feng3d.fagal.vertex.animation.V_VertexAnimationGPU;
	import me.feng3d.passes.MaterialPassBase;

	/**
	 * 顶点动画集合
	 * @author warden_feng 2014-5-30
	 */
	public class VertexAnimationSet extends AnimationSet
	{
		/**
		 * 创建一个顶点动画集合
		 */
		public function VertexAnimationSet()
		{
			super();
		}

		override arcane function activate(shaderParams:ShaderParams, stage3DProxy:Stage3DProxy, pass:MaterialPassBase):void
		{
			if (usesCPU)
				shaderParams.animationFagalMethod = V_VertexAnimationCPU;
			else
				shaderParams.animationFagalMethod = V_VertexAnimationGPU;
		}
	}
}

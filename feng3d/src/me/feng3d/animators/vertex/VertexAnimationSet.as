package me.feng3d.animators.vertex
{
	import me.feng3d.arcane;
	import me.feng3d.animators.AnimationType;
	import me.feng3d.animators.IAnimationSet;
	import me.feng3d.animators.base.AnimationSetBase;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.passes.MaterialPassBase;

	use namespace arcane;

	/**
	 * 顶点动画集合
	 * @author warden_feng 2014-5-30
	 */
	public class VertexAnimationSet extends AnimationSetBase implements IAnimationSet
	{
		private var _numPoses:uint;

		/**
		 * 创建一个顶点动画集合
		 * @param numPoses The number of poses made available at once to the GPU animation code.
		 */
		public function VertexAnimationSet(numPoses:uint = 2)
		{
			super();
			_numPoses = numPoses;
		}

		/**
		 * Returns the number of poses made available at once to the GPU animation code.
		 */
		public function get numPoses():uint
		{
			return _numPoses;
		}

		override public function activate(shaderParams:ShaderParams, pass:MaterialPassBase):void
		{
			if (usesCPU)
				shaderParams.animationType = AnimationType.VERTEX_CPU;
			else
				shaderParams.animationType = AnimationType.VERTEX_GPU;
		}
	}
}

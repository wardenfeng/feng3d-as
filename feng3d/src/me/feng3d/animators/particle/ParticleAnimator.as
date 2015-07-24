package me.feng3d.animators.particle
{
	import me.feng3d.arcane;
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.AnimationSetBase;
	import me.feng3d.animators.base.Animator;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	

	use namespace arcane;

	/**
	 * 粒子动画
	 * @author warden_feng 2014-11-13
	 */
	public class ParticleAnimator extends Animator implements IAnimator
	{
		private var _particleAnimationSet:ParticleAnimationSet;

		/** 常量数据 */
		private const vertexZeroConst:Vector.<Number> = Vector.<Number>([0, 1, 2, 0]);

		/** 时间常数（粒子当前时间） */
		private const timeConstData:Vector.<Number> = new Vector.<Number>(4);

		public function get animationSet():AnimationSetBase
		{
			return _particleAnimationSet;
		}

		/**
		 * 创建粒子动画
		 * @param particleAnimationSet 粒子动画集合
		 */
		public function ParticleAnimator(particleAnimationSet:ParticleAnimationSet)
		{
			super();
			_particleAnimationSet = particleAnimationSet;
			addChildBufferOwner(_particleAnimationSet);
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.particleCommon_vc_vector, updateParticleConstDataBuffer);
			mapContext3DBuffer(_.particleTime_vc_vector, updateTimeConstBuffer);
		}

		private function updateTimeConstBuffer(timeConstBuffer:VCVectorBuffer):void
		{
			timeConstBuffer.update(timeConstData);
		}

		private function updateParticleConstDataBuffer(particleConstDataBuffer:VCVectorBuffer):void
		{
			particleConstDataBuffer.update(vertexZeroConst);
		}

		public function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{
			var subMesh:SubMesh = renderable as SubMesh;

			if (!subMesh)
				throw(new Error("Must be subMesh"));

			if (!subMesh.animationSubGeometry)
				_particleAnimationSet.generateAnimationSubGeometries(subMesh.parentMesh);

			timeConstData[0] = timeConstData[1] = timeConstData[2] = timeConstData[3] = time / 1000;

			_particleAnimationSet.setRenderState(renderable, camera)
		}

	}
}

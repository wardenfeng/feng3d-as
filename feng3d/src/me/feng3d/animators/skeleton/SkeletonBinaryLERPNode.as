package me.feng3d.animators.skeleton
{
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.node.AnimationNodeBase;

	/**
	 * 两个骨骼动画节点间进行线性插值得出骨骼姿势
	 * @author warden_feng 2014-5-20
	 */
	public class SkeletonBinaryLERPNode extends AnimationNodeBase
	{
		/**
		 * 为混合输出提供输入节点A
		 */
		public var inputA:AnimationNodeBase;

		/**
		 * 为混合输出提供输入节点B
		 */
		public var inputB:AnimationNodeBase;

		/**
		 * 创建<code>SkeletonBinaryLERPNode</code>对象
		 */
		public function SkeletonBinaryLERPNode()
		{
			_stateClass = SkeletonBinaryLERPState;
		}

		/**
		 * @inheritDoc
		 */
		public function getAnimationState(animator:IAnimator):SkeletonBinaryLERPState
		{
			return animator.getAnimationState(this) as SkeletonBinaryLERPState;
		}
	}
}

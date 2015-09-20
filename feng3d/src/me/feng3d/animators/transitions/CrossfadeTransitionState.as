package me.feng3d.animators.transitions
{
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.skeleton.SkeletonBinaryLERPState;
	import me.feng3d.events.AnimationStateEvent;

	/**
	 * 淡入淡出变换状态
	 * @author warden_feng 2015-9-18
	 */
	public class CrossfadeTransitionState extends SkeletonBinaryLERPState
	{
		private var _skeletonAnimationNode:CrossfadeTransitionNode;
		private var _animationStateTransitionComplete:AnimationStateEvent;

		/**
		 * 创建淡入淡出变换状态实例
		 * @param animator						动画
		 * @param skeletonAnimationNode			骨骼动画节点
		 */
		function CrossfadeTransitionState(animator:IAnimator, skeletonAnimationNode:CrossfadeTransitionNode)
		{
			super(animator, skeletonAnimationNode);

			_skeletonAnimationNode = skeletonAnimationNode;
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateTime(time:int):void
		{
			blendWeight = Math.abs(time - _skeletonAnimationNode.startBlend) / (1000 * _skeletonAnimationNode.blendSpeed);

			if (blendWeight >= 1)
			{
				blendWeight = 1;
				_skeletonAnimationNode.dispatchEvent(_animationStateTransitionComplete ||= new AnimationStateEvent(AnimationStateEvent.TRANSITION_COMPLETE, _animator, this, _skeletonAnimationNode));
			}

			super.updateTime(time);
		}
	}
}

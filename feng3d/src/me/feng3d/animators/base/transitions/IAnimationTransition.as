package me.feng3d.animators.base.transitions
{
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.node.AnimationNodeBase;

	/**
	 * 淡入淡出变换接口
	 * @author feng 2015-9-18
	 */
	public interface IAnimationTransition
	{
		/**
		 * 获取动画变换节点
		 * @param animator				动画
		 * @param startNode				开始节点
		 * @param endNode				结束节点
		 * @param startTime				开始时间
		 * @return						动画变换节点
		 */
		function getAnimationNode(animator:IAnimator, startNode:AnimationNodeBase, endNode:AnimationNodeBase, startTime:int):AnimationNodeBase
	}
}

package me.feng3d.animators.base.transitions
{
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.node.AnimationNodeBase;

	public interface IAnimationTransition
	{
		function getAnimationNode(animator:IAnimator, startNode:AnimationNodeBase, endNode:AnimationNodeBase, startTime:int):AnimationNodeBase
	}
}

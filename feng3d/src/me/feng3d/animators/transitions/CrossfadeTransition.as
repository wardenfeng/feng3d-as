package me.feng3d.animators.transitions
{
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.node.AnimationNodeBase;
	import me.feng3d.animators.base.transitions.IAnimationTransition;

	public class CrossfadeTransition implements IAnimationTransition
	{
		public var blendSpeed:Number = 0.5;

		public function CrossfadeTransition(blendSpeed:Number)
		{
			this.blendSpeed = blendSpeed;
		}

		public function getAnimationNode(animator:IAnimator, startNode:AnimationNodeBase, endNode:AnimationNodeBase, startBlend:int):AnimationNodeBase
		{
			var crossFadeTransitionNode:CrossfadeTransitionNode = new CrossfadeTransitionNode();
			crossFadeTransitionNode.inputA = startNode;
			crossFadeTransitionNode.inputB = endNode;
			crossFadeTransitionNode.blendSpeed = blendSpeed;
			crossFadeTransitionNode.startBlend = startBlend;

			return crossFadeTransitionNode;
		}
	}
}

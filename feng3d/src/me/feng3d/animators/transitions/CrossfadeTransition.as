package me.feng3d.animators.transitions
{
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.node.AnimationNodeBase;
	import me.feng3d.animators.base.transitions.IAnimationTransition;

	/**
	 * 淡入淡出变换
	 * @author warden_feng 2015-9-18
	 */
	public class CrossfadeTransition implements IAnimationTransition
	{
		public var blendSpeed:Number = 0.5;

		/**
		 * 创建淡入淡出变换实例
		 * @param blendSpeed			混合速度
		 */
		public function CrossfadeTransition(blendSpeed:Number)
		{
			this.blendSpeed = blendSpeed;
		}

		/**
		 * @inheritDoc
		 */
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

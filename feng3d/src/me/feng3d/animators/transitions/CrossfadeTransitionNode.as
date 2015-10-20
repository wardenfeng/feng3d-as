package me.feng3d.animators.transitions
{
	import me.feng3d.animators.skeleton.SkeletonBinaryLERPNode;

	/**
	 * 淡入淡出变换节点
	 * @author feng 2014-5-20
	 */
	public class CrossfadeTransitionNode extends SkeletonBinaryLERPNode
	{
		/**
		 * 混合速度
		 */
		public var blendSpeed:Number;

		/**
		 * 开始混合
		 */
		public var startBlend:int;

		/**
		 * 创建<code>CrossfadeTransitionNode</code>实例
		 */
		public function CrossfadeTransitionNode()
		{
			_stateClass = CrossfadeTransitionState;
		}
	}
}

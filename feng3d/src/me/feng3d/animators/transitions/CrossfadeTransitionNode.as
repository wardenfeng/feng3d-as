package me.feng3d.animators.transitions
{
	import me.feng3d.animators.skeleton.SkeletonBinaryLERPNode;

	/**
	 * A skeleton animation node that uses two animation node inputs to blend a lineraly interpolated output of a skeleton pose.
	 */
	public class CrossfadeTransitionNode extends SkeletonBinaryLERPNode
	{
		public var blendSpeed:Number;

		public var startBlend:int;

		/**
		 * Creates a new <code>CrossfadeTransitionNode</code> object.
		 */
		public function CrossfadeTransitionNode()
		{
			_stateClass = CrossfadeTransitionState;
		}
	}
}

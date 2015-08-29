package me.feng3d.animators.skeleton
{
	import me.feng3d.animators.base.states.IAnimationState;
	import me.feng3d.animators.skeleton.data.Skeleton;
	import me.feng3d.animators.skeleton.data.SkeletonPose;

	public interface ISkeletonAnimationState extends IAnimationState
	{
		/**
		 * Returns the output skeleton pose of the animation node.
		 */
		function getSkeletonPose(skeleton:Skeleton):SkeletonPose;
	}
}

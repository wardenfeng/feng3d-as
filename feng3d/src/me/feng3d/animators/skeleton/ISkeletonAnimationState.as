package me.feng3d.animators.skeleton
{
	import me.feng3d.animators.base.states.IAnimationState;
	import me.feng3d.animators.skeleton.data.Skeleton;
	import me.feng3d.animators.skeleton.data.SkeletonPose;

	/**
	 * 骨骼动画状态接口
	 * @author warden_feng 2015-9-18
	 */
	public interface ISkeletonAnimationState extends IAnimationState
	{
		/**
		 * 获取骨骼姿势
		 * @param skeleton		骨骼
		 */
		function getSkeletonPose(skeleton:Skeleton):SkeletonPose;
	}
}

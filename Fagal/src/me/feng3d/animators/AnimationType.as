package me.feng3d.animators
{
	import me.feng.enum.Enum;

	/**
	 * 动画类型
	 * @author warden_feng 2015-1-27
	 */
	public class AnimationType extends Enum
	{
		/** 没有动画 */
		public static const NONE:AnimationType = new AnimationType();

		/** 顶点动画由GPU计算 */
		public static const VERTEX_CPU:AnimationType = new AnimationType();

		/** 顶点动画由GPU计算 */
		public static const VERTEX_GPU:AnimationType = new AnimationType();

		/** 骨骼动画由GPU计算 */
		public static const SKELETON_CPU:AnimationType = new AnimationType();

		/** 骨骼动画由GPU计算 */
		public static const SKELETON_GPU:AnimationType = new AnimationType();

		/** 粒子特效 */
		public static const PARTICLE:AnimationType = new AnimationType();
	}
}

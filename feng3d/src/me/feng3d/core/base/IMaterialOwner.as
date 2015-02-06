package me.feng3d.core.base
{
	import me.feng3d.animators.IAnimator;
	import me.feng3d.materials.MaterialBase;

	/**
	 * 材质拥有者
	 * IMaterialOwner为一个对象提供能够使用材质的接口
	 * IMaterialOwner provides an interface for objects that can use materials.
	 */
	public interface IMaterialOwner
	{
		/**
		 * 渲染材质
		 */
		function get material():MaterialBase;

		/**
		 * 动画
		 */
		function get animator():IAnimator;
	}
}

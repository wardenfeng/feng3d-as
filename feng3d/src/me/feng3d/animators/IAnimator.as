package me.feng3d.animators
{
	import me.feng3d.animators.base.node.AnimationNodeBase;
	import me.feng3d.animators.base.states.AnimationStateBase;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.IContext3DBufferOwner;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.entities.Mesh;

	/**
	 * 动画接口
	 * @author feng 2015-1-30
	 */
	public interface IAnimator extends IContext3DBufferOwner
	{
		/**
		 * 获取动画集合基类
		 */
		function get animationSet():IAnimationSet;

		/**
		 * 设置渲染状态
		 * @param stage3DProxy			显卡代理
		 * @param renderable			渲染实体
		 * @param vertexConstantOffset
		 * @param vertexStreamOffset
		 * @param camera				摄像机
		 */
		function setRenderState(renderable:IRenderable, camera:Camera3D):void;

		/**
		 * 获取动画状态
		 * @param node		动画节点
		 * @return			动画状态
		 */
		function getAnimationState(node:AnimationNodeBase):AnimationStateBase;

		/**
		 * 添加应用动画的网格
		 * @private
		 */
		function addOwner(mesh:Mesh):void

		/**
		 * 移除应用动画的网格
		 * @private
		 */
		function removeOwner(mesh:Mesh):void
	}
}

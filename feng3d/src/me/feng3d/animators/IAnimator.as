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
	 * @author warden_feng 2015-1-30
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

		function getAnimationState(node:AnimationNodeBase):AnimationStateBase;

		/**
		 * Used by the mesh object to which the animator is applied, registers the owner for internal use.
		 *
		 * @private
		 */
		function addOwner(mesh:Mesh):void

		/**
		 * Used by the mesh object from which the animator is removed, unregisters the owner for internal use.
		 *
		 * @private
		 */
		function removeOwner(mesh:Mesh):void
	}
}

package me.feng3d.animators
{
	import me.feng3d.animators.base.node.AnimationNodeBase;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.passes.MaterialPassBase;

	/**
	 * 提供动画数据集合的接口
	 * @author warden_feng 2015-9-18
	 */
	public interface IAnimationSet
	{
		/**
		 * 检查是否有该动作名称
		 * @param name			动作名称
		 */
		function hasAnimation(name:String):Boolean;

		/**
		 * 获取动画节点
		 * @param name			动作名称
		 */
		function getAnimation(name:String):AnimationNodeBase;

		/**
		 * 判断是否使用CPU计算
		 * @private
		 */
		function get usesCPU():Boolean;

		/**
		 * 取消使用GPU计算
		 * @private
		 */
		function cancelGPUCompatibility():void;

		/**
		 * 激活状态，收集GPU渲染所需数据及其状态
		 * @param shaderParams			渲染参数
		 * @param pass					材质渲染通道
		 */
		function activate(shaderParams:ShaderParams, pass:MaterialPassBase):void
	}
}

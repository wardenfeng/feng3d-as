package me.feng3d.animators.uv
{
	import me.feng3d.animators.IAnimationSet;
	import me.feng3d.animators.base.AnimationSetBase;
	import me.feng3d.fagal.params.AnimationShaderParams;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.passes.MaterialPassBase;

	/**
	 * UV动画集合
	 * @author feng 2014-5-20
	 */
	public class UVAnimationSet extends AnimationSetBase implements IAnimationSet
	{
		/**
		 * 创建UV动画集合实例
		 */
		public function UVAnimationSet()
		{

		}

		/**
		 * @inheritDoc
		 */
		override public function activate(shaderParams:ShaderParams, pass:MaterialPassBase):void
		{
			var animationShaderParams:AnimationShaderParams = shaderParams.getComponentByClass(AnimationShaderParams);
			animationShaderParams.useUVAnimation++;
		}
	}
}

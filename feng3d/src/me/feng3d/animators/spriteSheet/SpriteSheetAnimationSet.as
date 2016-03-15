package me.feng3d.animators.spriteSheet
{
	import me.feng3d.animators.IAnimationSet;
	import me.feng3d.animators.base.AnimationSetBase;
	import me.feng3d.fagal.params.AnimationShaderParams;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.passes.MaterialPassBase;

	/**
	 * sprite动画集合
	 * @author feng 2015-9-18
	 */
	public class SpriteSheetAnimationSet extends AnimationSetBase implements IAnimationSet
	{
		/**
		 * 创建sprite动画集合
		 */
		function SpriteSheetAnimationSet()
		{
		}

		/**
		 * @inheritDoc
		 */
		override public function activate(shaderParams:ShaderParams, pass:MaterialPassBase):void
		{
			var animationShaderParams:AnimationShaderParams = shaderParams.getOrCreateComponentByClass(AnimationShaderParams);
			animationShaderParams.useSpriteSheetAnimation++;
		}
	}
}


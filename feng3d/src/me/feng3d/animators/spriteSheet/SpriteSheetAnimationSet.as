package me.feng3d.animators.spriteSheet
{
	import me.feng3d.animators.IAnimationSet;
	import me.feng3d.animators.base.AnimationSetBase;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.passes.MaterialPassBase;

	/**
	 * The animation data set containing the Spritesheet animation state data.
	 *
	 * @see away3d.animators.SpriteSheetAnimator
	 * @see away3d.animators.SpriteSheetAnimationState
	 */
	public class SpriteSheetAnimationSet extends AnimationSetBase implements IAnimationSet
	{
		private var _agalCode:String;

		function SpriteSheetAnimationSet()
		{
		}

		/**
		 * @inheritDoc
		 */
		override public function activate(shaderParams:ShaderParams, pass:MaterialPassBase):void
		{
			shaderParams.useSpriteSheetAnimation++;
		}
	}
}


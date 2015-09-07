package me.feng3d.animators.uv
{
	import me.feng3d.animators.IAnimationSet;
	import me.feng3d.animators.base.AnimationSetBase;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.passes.MaterialPassBase;

	/**
	 * The animation data set used by uv-based animators, containing uv animation state data.
	 *
	 * @see away3d.animators.UVAnimator
	 * @see away3d.animators.UVAnimationState
	 */
	public class UVAnimationSet extends AnimationSetBase implements IAnimationSet
	{
		private var _agalCode:String;

		public function UVAnimationSet()
		{

		}

		/**
		 * @inheritDoc
		 */
		override public function activate(shaderParams:ShaderParams, pass:MaterialPassBase):void
		{
			shaderParams.useUVAnimation++;
		}
	}
}

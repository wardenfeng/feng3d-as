package me.feng3d.animators.base
{
	import flash.utils.Dictionary;

	/**
	 * 多动作(片段、剪辑)动画
	 * @author warden_feng 2015-1-30
	 */
	public class MultiClipAnimator extends FrameAnimator
	{
		protected var _activeAnimationName:String;

		private var _animationStates:Dictionary = new Dictionary(true);

		public function MultiClipAnimator()
		{
			super();
		}
	}
}

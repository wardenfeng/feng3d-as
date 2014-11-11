package me.feng3d.events
{
	import me.feng.events.FEvent;
	import me.feng3d.animators.Animator;
	import me.feng3d.animators.nodes.AnimationNode;
	import me.feng3d.animators.states.AnimationState;
	
	
	/**
	 * 动画状态事件
	 * @author warden_feng 2014-5-27
	 */
	public class AnimationStateEvent extends FEvent
	{
		/** 播放到最后 */
		public static const PLAYBACK_COMPLETE:String = "playbackComplete";
		
		public static const TRANSITION_COMPLETE:String = "transitionComplete";
		
		private var _animator:Animator;
		private var _animationState:AnimationState;
		private var _animationNode:AnimationNode;
		
		public function AnimationStateEvent(type:String, animator:Animator, animationState:AnimationState, animationNode:AnimationNode)
		{
			super(type, data, bubbles);
			
			_animator = animator;
			_animationState = animationState;
			_animationNode = animationNode;
		}
		
		public function get animationNode():AnimationNode
		{
			return _animationNode;
		}
		
		public function get animationState():AnimationState
		{
			return _animationState;
		}
	}
}
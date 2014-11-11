package me.feng3d.animators.states
{
	import me.feng3d.animators.Animator;
	import me.feng3d.animators.nodes.AnimationClipNode;
	import me.feng3d.events.AnimationStateEvent;

	/**
	 * 动画剪辑状态
	 * @author warden_feng 2014-5-29
	 */
	public class AnimationClipState extends AnimationState
	{
		/** 动画节点 */
		private var _animationClipNode:AnimationClipNode;
		/**  */
		private var _animationStatePlaybackComplete:AnimationStateEvent;
		/** 混合权重 */
		protected var _blendWeight:Number;
		protected var _currentFrame:uint;
		protected var _nextFrame:uint;

		protected var _oldFrame:uint;
		protected var _timeDir:int;
		protected var _framesDirty:Boolean = true;

		/**
		 * 下一帧编号
		 */
		public function get nextFrame():uint
		{
			if (_framesDirty)
				updateFrames();

			return _nextFrame;
		}

		/**
		 * 混合权重
		 */
		public function get blendWeight():Number
		{
			if (_framesDirty)
				updateFrames();

			return _blendWeight;
		}

		/**
		 * 创建一个动画剪辑节点状态
		 * @param animator 动画
		 * @param animationClipNode 动画节点
		 */
		public function AnimationClipState(animator:Animator, animationClipNode:AnimationClipNode)
		{
			super(animator, animationClipNode);

			_animationClipNode = animationClipNode;
		}

		override protected function updateTime(time:int):void
		{
			_framesDirty = true;

			_timeDir = (time - _startTime > _time) ? 1 : -1;

			super.updateTime(time);
		}

		/**
		 * 更新动画帧
		 */
		protected function updateFrames():void
		{
			_framesDirty = false;

			var looping:Boolean = _animationClipNode.looping;
			var totalDuration:uint = _animationClipNode.totalDuration;
			var lastFrame:uint = _animationClipNode.lastFrame;
			var time:int = _time;

			//修正time值在周期与0之间
			if (looping && (time >= totalDuration || time < 0))
			{
				time %= totalDuration;
				if (time < 0)
					time += totalDuration;
			}

			//无循环时，时间大于总周期，直接跳转到最后一帧
			if (!looping && time >= totalDuration)
			{
				notifyPlaybackComplete();
				_currentFrame = lastFrame;
				_nextFrame = lastFrame;
				_blendWeight = 0;
			}
			//无循环时，时间小于0，直接跳转到第一帧
			else if (!looping && time <= 0)
			{
				_currentFrame = 0;
				_nextFrame = 0;
				_blendWeight = 0;
			}
			//固定帧时，直接跳转到下一帧
			else if (_animationClipNode.fixedFrameRate)
			{
				var t:Number = time / totalDuration * lastFrame;
				_currentFrame = t;
				_blendWeight = t - _currentFrame;
				_nextFrame = _currentFrame + 1;
			}
			else
			{
				//根据实际过去的时间跳转到应当所在的帧位置
				_currentFrame = 0;
				_nextFrame = 0;

				var dur:uint = 0, frameTime:uint;
				var durations:Vector.<uint> = _animationClipNode.durations;

				do
				{
					frameTime = dur;
					dur += durations[nextFrame];
					_currentFrame = _nextFrame++;
				} while (time > dur);

				if (_currentFrame == lastFrame)
				{
					_currentFrame = 0;
					_nextFrame = 1;
				}

				_blendWeight = (time - frameTime) / durations[_currentFrame];
			}
		}

		/**
		 * 通知播放到最后（结束当前循环）
		 */
		private function notifyPlaybackComplete():void
		{
			_animationClipNode.dispatchEvent(_animationStatePlaybackComplete ||= new AnimationStateEvent(AnimationStateEvent.PLAYBACK_COMPLETE, _animator, this, _animationClipNode));
		}
	}
}

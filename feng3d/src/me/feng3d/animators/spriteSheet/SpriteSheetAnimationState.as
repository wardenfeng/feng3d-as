package me.feng3d.animators.spriteSheet
{
	import me.feng3d.arcane;
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.states.AnimationClipState;

	use namespace arcane;

	/**
	 * sprite动画状态
	 * @author feng 2015-9-18
	 */
	public class SpriteSheetAnimationState extends AnimationClipState implements ISpriteSheetAnimationState
	{
		private var _frames:Vector.<SpriteSheetAnimationFrame>;
		private var _clipNode:SpriteSheetClipNode;
		private var _currentFrameID:uint = 0;
		private var _reverse:Boolean;
		private var _backAndForth:Boolean;
		private var _forcedFrame:Boolean;

		/**
		 * 创建sprite动画状态实例
		 * @param animator			动画
		 * @param clipNode			动画剪辑节点
		 */
		function SpriteSheetAnimationState(animator:IAnimator, clipNode:SpriteSheetClipNode)
		{
			super(animator, clipNode);

			_clipNode = clipNode;
			_frames = _clipNode.frames;
		}

		/**
		 * 是否反向播放
		 */
		public function set reverse(b:Boolean):void
		{
			_reverse = b;
		}

		/**
		 * 改变播放方向
		 */
		public function set backAndForth(b:Boolean):void
		{
			if (b)
				_reverse = false;
			_backAndForth = b;
		}

		/**
		 * @inheritDoc
		 */
		public function get currentFrameData():SpriteSheetAnimationFrame
		{
			if (_framesDirty)
				updateFrames();

			return _frames[_currentFrameID];
		}

		/**
		 * 当前帧数
		 */
		public function get currentFrameNumber():uint
		{
			return _currentFrameID;
		}

		public function set currentFrameNumber(frameNumber:uint):void
		{
			_currentFrameID = (frameNumber > _frames.length - 1) ? _frames.length - 1 : frameNumber;
			_forcedFrame = true;
		}

		/**
		 * 总帧数
		 */
		arcane function get totalFrames():uint
		{
			return (!_frames) ? 0 : _frames.length;
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateFrames():void
		{
			if (_forcedFrame)
			{
				_forcedFrame = false;
				return;
			}

			super.updateFrames();

			if (_reverse)
			{

				if (_currentFrameID - 1 > -1)
					_currentFrameID--;

				else
				{

					if (_clipNode.looping)
					{

						if (_backAndForth)
						{
							_reverse = false;
							_currentFrameID++;
						}
						else
							_currentFrameID = _frames.length - 1;
					}

					SpriteSheetAnimator(_animator).dispatchCycleEvent();
				}

			}
			else
			{

				if (_currentFrameID < _frames.length - 1)
					_currentFrameID++;

				else
				{

					if (_clipNode.looping)
					{

						if (_backAndForth)
						{
							_reverse = true;
							_currentFrameID--;
						}
						else
							_currentFrameID = 0;
					}

					SpriteSheetAnimator(_animator).dispatchCycleEvent();
				}
			}

		}
	}
}

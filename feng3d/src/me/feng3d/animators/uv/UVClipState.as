package me.feng3d.animators.uv
{
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.states.AnimationClipState;

	/**
	 * UV动画剪辑状态
	 * @author feng 2015-9-18
	 */
	public class UVClipState extends AnimationClipState implements IUVAnimationState
	{
		private var _frames:Vector.<UVAnimationFrame>;
		private var _uvClipNode:UVClipNode;
		private var _currentUVFrame:UVAnimationFrame;
		private var _nextUVFrame:UVAnimationFrame;

		/**
		 * @inheritDoc
		 */
		public function get currentUVFrame():UVAnimationFrame
		{
			if (_framesDirty)
				updateFrames();

			return _currentUVFrame;
		}

		/**
		 * @inheritDoc
		 */
		public function get nextUVFrame():UVAnimationFrame
		{
			if (_framesDirty)
				updateFrames();

			return _nextUVFrame;
		}

		/**
		 * 创建UVClipState实例
		 * @param animator				动画
		 * @param uvClipNode			UV动画剪辑节点
		 */
		function UVClipState(animator:IAnimator, uvClipNode:UVClipNode)
		{
			super(animator, uvClipNode);

			_uvClipNode = uvClipNode;
			_frames = _uvClipNode.frames;
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateFrames():void
		{
			super.updateFrames();

			if (_frames.length > 0)
			{

				if (_frames.length == 2 && _currentFrame == 0)
				{

					_currentUVFrame = _frames[1];
					_nextUVFrame = _frames[0];

				}
				else
				{

					_currentUVFrame = _frames[_currentFrame];

					if (_uvClipNode.looping && _nextFrame >= _uvClipNode.lastFrame)
						_nextUVFrame = _frames[0];
					else
						_nextUVFrame = _frames[_nextFrame];

				}

			}
		}

	}
}

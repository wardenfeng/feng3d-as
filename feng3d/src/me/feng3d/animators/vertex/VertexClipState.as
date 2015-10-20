package me.feng3d.animators.vertex
{
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.states.AnimationClipState;
	import me.feng3d.core.base.Geometry;

	/**
	 * 顶点动画剪辑状态
	 * @author feng 2015-9-18
	 */
	public class VertexClipState extends AnimationClipState implements IVertexAnimationState
	{
		private var _frames:Vector.<Geometry>;
		private var _vertexClipNode:VertexClipNode;
		private var _currentGeometry:Geometry;
		private var _nextGeometry:Geometry;

		/**
		 * @inheritDoc
		 */
		public function get currentGeometry():Geometry
		{
			if (_framesDirty)
				updateFrames();

			return _currentGeometry;
		}

		/**
		 * @inheritDoc
		 */
		public function get nextGeometry():Geometry
		{
			if (_framesDirty)
				updateFrames();

			return _nextGeometry;
		}

		/**
		 * 创建VertexClipState实例
		 * @param animator				动画
		 * @param vertexClipNode		顶点动画节点
		 */
		function VertexClipState(animator:IAnimator, vertexClipNode:VertexClipNode)
		{
			super(animator, vertexClipNode);

			_vertexClipNode = vertexClipNode;
			_frames = _vertexClipNode.frames;
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateFrames():void
		{
			super.updateFrames();

			_currentGeometry = _frames[_currentFrame];

			if (_vertexClipNode.looping && _nextFrame >= _vertexClipNode.lastFrame)
			{
				_nextGeometry = _frames[0];
				VertexAnimator(_animator).dispatchCycleEvent();
			}
			else
				_nextGeometry = _frames[_nextFrame];
		}
	}
}

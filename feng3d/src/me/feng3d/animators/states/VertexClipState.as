package me.feng3d.animators.states
{
	import me.feng3d.animators.Animator;
	import me.feng3d.animators.VertexAnimator;
	import me.feng3d.animators.nodes.VertexClipNode;
	import me.feng3d.core.base.Geometry;

	/**
	 * 顶点动画剪辑状态
	 * @author warden_feng 2014-5-30
	 */
	public class VertexClipState extends AnimationClipState
	{
		private var _frames:Vector.<Geometry>;
		private var _vertexClipNode:VertexClipNode;

		private var _currentGeometry:Geometry;
		private var _nextGeometry:Geometry;

		/**
		 * 创建一个顶点动画
		 * @param animator 动画类
		 * @param vertexClipNode 顶点剪辑节点
		 */
		public function VertexClipState(animator:Animator, vertexClipNode:VertexClipNode)
		{
			super(animator, vertexClipNode);

			_vertexClipNode = vertexClipNode;
			_frames = _vertexClipNode.frames;
		}

		/**
		 * 当前帧几何体
		 */
		public function get currentGeometry():Geometry
		{
			if (_framesDirty)
				updateFrames();

			return _currentGeometry;
		}

		/**
		 * 下一帧几何体
		 */
		public function get nextGeometry():Geometry
		{
			if (_framesDirty)
				updateFrames();

			return _nextGeometry;
		}

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

package me.feng3d.animators.base.states
{
	import flash.geom.Vector3D;

	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.node.AnimationNodeBase;

	/**
	 * 动画状态基类
	 * @author warden_feng 2015-9-18
	 */
	public class AnimationStateBase implements IAnimationState
	{
		protected var _animationNode:AnimationNodeBase;
		protected var _rootDelta:Vector3D = new Vector3D();
		protected var _positionDeltaDirty:Boolean = true;

		protected var _time:int;
		protected var _startTime:int;
		protected var _animator:IAnimator;

		/**
		 * @inheritDoc
		 */
		public function get positionDelta():Vector3D
		{
			if (_positionDeltaDirty)
				updatePositionDelta();

			return _rootDelta;
		}

		/**
		 * 创建动画状态基类
		 * @param animator				动画
		 * @param animationNode			动画节点
		 */
		function AnimationStateBase(animator:IAnimator, animationNode:AnimationNodeBase)
		{
			_animator = animator;
			_animationNode = animationNode;
		}

		/**
		 * @inheritDoc
		 */
		public function offset(startTime:int):void
		{
			_startTime = startTime;

			_positionDeltaDirty = true;
		}

		/**
		 * @inheritDoc
		 */
		public function update(time:int):void
		{
			if (_time == time - _startTime)
				return;

			updateTime(time);
		}

		/**
		 * @inheritDoc
		 */
		public function phase(value:Number):void
		{
		}

		/**
		 * 更新时间
		 * @param time		当前时间
		 */
		protected function updateTime(time:int):void
		{
			_time = time - _startTime;

			_positionDeltaDirty = true;
		}

		/**
		 * 位置偏移
		 */
		protected function updatePositionDelta():void
		{
		}
	}
}

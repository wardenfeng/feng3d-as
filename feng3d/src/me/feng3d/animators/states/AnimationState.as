package me.feng3d.animators.states
{
	import flash.geom.Vector3D;
	
	import me.feng3d.animators.Animator;
	import me.feng3d.animators.nodes.AnimationNode;

	/**
	 * 动画状态基类
	 * @author warden_feng 2014-5-27
	 */
	public class AnimationState
	{
		/** 动画节点 */
		protected var _animationNode:AnimationNode;
		/** 骨骼根节点偏移位置 */
		protected var _rootDelta:Vector3D = new Vector3D();
		protected var _positionDeltaDirty:Boolean = true;

		protected var _time:int;
		protected var _startTime:int;
		protected var _animator:Animator;

		/**
		 * 创建一个动画状态基类
		 * @param animator 动画
		 * @param animationNode 动画节点
		 */
		public function AnimationState(animator:Animator, animationNode:AnimationNode)
		{
			_animator = animator;
			_animationNode = animationNode;
		}

		/**
		 * 位置偏移量
		 */
		public function get positionDelta():Vector3D
		{
			if (_positionDeltaDirty)
				updatePositionDelta();

			return _rootDelta;
		}

		/**
		 * 更新动画状态
		 * @param time 动画时间
		 */
		public function update(time:int):void
		{
			if (_time == time - _startTime)
				return;

			updateTime(time);
		}

		/**
		 * 设置偏移时间
		 * @param startTime
		 */
		public function offset(startTime:int):void
		{
			_startTime = startTime;

			_positionDeltaDirty = true;
		}

		/**
		 * 更新动画时间
		 * @param time 更新动画
		 */
		protected function updateTime(time:int):void
		{
			_time = time - _startTime;

			_positionDeltaDirty = true;
		}

		/**
		 * 更新位置偏移量
		 */
		protected function updatePositionDelta():void
		{
		}
	}
}

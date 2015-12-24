package me.feng3d.animators.base
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	import me.feng.error.AbstractMethodError;
	import me.feng3d.animators.IAnimationSet;
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.node.AnimationNodeBase;
	import me.feng3d.animators.base.states.AnimationStateBase;
	import me.feng3d.animators.base.states.IAnimationState;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.entities.Mesh;
	import me.feng3d.events.AnimatorEvent;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;

	/**
	 * 当开始播放动画时触发
	 * @eventType me.feng3d.events.AnimatorEvent
	 */
	[Event(name = "start", type = "me.feng3d.events.AnimatorEvent")]

	/**
	 * 当动画停止时触发
	 * @eventType me.feng3d.events.AnimatorEvent
	 */
	[Event(name = "stop", type = "me.feng3d.events.AnimatorEvent")]

	/**
	 * 当动画播放完一次时触发
	 * @eventType me.feng3d.events.AnimatorEvent
	 */
	[Event(name = "cycle_complete", type = "me.feng3d.events.AnimatorEvent")]

	/**
	 * 动画基类
	 * @author feng 2014-5-27
	 */
	public class AnimatorBase extends Context3DBufferOwner implements IAsset, IAnimator
	{
		/** 动画驱动器 */
		private var _broadcaster:Sprite = new Sprite();
		/** 是否正在播放动画 */
		private var _isPlaying:Boolean;
		private var _autoUpdate:Boolean = true;
		private var _time:int;
		/** 播放速度 */
		private var _playbackSpeed:Number = 1;

		protected var _animationSet:IAnimationSet;
		protected var _owners:Vector.<Mesh> = new Vector.<Mesh>();
		protected var _activeNode:AnimationNodeBase;
		protected var _activeState:IAnimationState;
		protected var _activeAnimationName:String;
		/** 当前动画时间 */
		protected var _absoluteTime:Number;
		private var _animationStates:Dictionary = new Dictionary(true);

		/**
		 * 是否更新位置
		 * @see me.feng3d.animators.base.states.IAnimationState#positionDelta
		 */
		public var updatePosition:Boolean = true;

		/**
		 * 创建一个动画基类
		 * @param animationSet
		 */
		public function AnimatorBase(animationSet:IAnimationSet)
		{
			_animationSet = animationSet;
		}

		/**
		 * 获取动画状态
		 * @param node		动画节点
		 * @return			动画状态
		 */
		public function getAnimationState(node:AnimationNodeBase):AnimationStateBase
		{
			var className:Class = node.stateClass;

			return _animationStates[node] ||= new className(this, node);
		}

		/**
		 * 根据名字获取动画状态
		 * @param name			动作名称
		 * @return				动画状态
		 */
		public function getAnimationStateByName(name:String):AnimationStateBase
		{
			return getAnimationState(_animationSet.getAnimation(name));
		}


		/**
		 * 绝对时间（游戏时间）
		 * @see #time
		 * @see #playbackSpeed
		 */
		public function get absoluteTime():Number
		{
			return _absoluteTime;
		}

		/**
		 * 动画设置
		 */
		public function get animationSet():IAnimationSet
		{
			return _animationSet;
		}

		/**
		 * 活动的动画状态
		 */
		public function get activeState():IAnimationState
		{
			return _activeState;
		}

		/**
		 * 活动的动画节点
		 */
		public function get activeAnimation():AnimationNodeBase
		{
			return _animationSet.getAnimation(_activeAnimationName);
		}

		/**
		 * 活动的动作名
		 */
		public function get activeAnimationName():String
		{
			return _activeAnimationName;
		}

		/**
		 * 是否自动更新，当值为true时，动画将会随时间播放
		 * @see #time
		 * @see #update()
		 */
		public function get autoUpdate():Boolean
		{
			return _autoUpdate;
		}

		public function set autoUpdate(value:Boolean):void
		{
			if (_autoUpdate == value)
				return;

			_autoUpdate = value;

			if (_autoUpdate)
				start();
			else
				stop();
		}

		/**
		 * 动画时间
		 */
		public function get time():int
		{
			return _time;
		}

		public function set time(value:int):void
		{
			if (_time == value)
				return;

			update(value);
		}

		/**
		 * 设置当前活动状态的动画剪辑的播放进度(0,1)
		 * @param	播放进度。 0：动画起点，1：动画终点。
		 */
		public function phase(value:Number):void
		{
			_activeState.phase(value);
		}

		/**
		 * The amount by which passed time should be scaled. Used to slow down or speed up animations. Defaults to 1.
		 */
		/**
		 * 播放速度
		 * <p>默认为1，表示正常速度</p>
		 */
		public function get playbackSpeed():Number
		{
			return _playbackSpeed;
		}

		public function set playbackSpeed(value:Number):void
		{
			_playbackSpeed = value;
		}

		/**
		 * 开始动画，当自动更新为true时有效
		 * @see #autoUpdate
		 */
		public function start():void
		{
			if (_isPlaying || !_autoUpdate)
				return;

			_time = _absoluteTime = getTimer();

			_isPlaying = true;

			if (!_broadcaster.hasEventListener(Event.ENTER_FRAME))
				_broadcaster.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			if (!hasEventListener(AnimatorEvent.START))
				return;

			dispatchEvent(new AnimatorEvent(AnimatorEvent.START, this));
		}


		/**
		 * 暂停播放动画
		 * @see #time
		 * @see #update()
		 */
		public function stop():void
		{
			if (!_isPlaying)
				return;

			_isPlaying = false;

			if (_broadcaster.hasEventListener(Event.ENTER_FRAME))
				_broadcaster.removeEventListener(Event.ENTER_FRAME, onEnterFrame);

			if (!hasEventListener(AnimatorEvent.STOP))
				return;

			dispatchEvent(new AnimatorEvent(AnimatorEvent.STOP, this));
		}

		/**
		 * 更新动画
		 * @param time			动画时间
		 *
		 * @see #stop()
		 * @see #autoUpdate
		 */
		public function update(time:int):void
		{
			var dt:Number = (time - _time) * playbackSpeed;

			updateDeltaTime(dt);

			_time = time;
		}

		/**
		 * 重置动画
		 * @param name			动画名称
		 * @param offset		动画时间偏移
		 */
		public function reset(name:String, offset:Number = 0):void
		{
			getAnimationState(_animationSet.getAnimation(name)).offset(offset + _absoluteTime);
		}

		/**
		 * 添加应用动画的网格
		 * @private
		 */
		public function addOwner(mesh:Mesh):void
		{
			_owners.push(mesh);
		}

		/**
		 * 移除应用动画的网格
		 * @private
		 */
		public function removeOwner(mesh:Mesh):void
		{
			_owners.splice(_owners.indexOf(mesh), 1);
		}

		/**
		 * 更新偏移时间
		 * @private
		 */
		protected function updateDeltaTime(dt:Number):void
		{
			_absoluteTime += dt;

			_activeState.update(_absoluteTime);

			if (updatePosition)
				applyPositionDelta();
		}

		/**
		 * 自动更新动画时帧更新事件
		 */
		private function onEnterFrame(event:Event = null):void
		{
			update(getTimer());
		}

		/**
		 * 应用位置偏移量
		 */
		private function applyPositionDelta():void
		{
			var delta:Vector3D = _activeState.positionDelta;
			var dist:Number = delta.length;
			var len:uint;
			if (dist > 0)
			{
				len = _owners.length;
				for (var i:uint = 0; i < len; ++i)
					_owners[i].translateLocal(delta, dist);
			}
		}

		/**
		 * 派发动画播放完成一周期事件
		 * @private
		 */
		public function dispatchCycleEvent():void
		{
			if (hasEventListener(AnimatorEvent.CYCLE_COMPLETE))
				dispatchEvent(new AnimatorEvent(AnimatorEvent.CYCLE_COMPLETE, this));
		}

		/**
		 * @inheritDoc
		 */
		public function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{
			throw new AbstractMethodError();
		}

		/**
		 * @inheritDoc
		 */
		public function get assetType():String
		{
			return AssetType.ANIMATOR;
		}
	}
}

package me.feng3d.animators
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import me.feng3d.animators.nodes.AnimationNode;
	import me.feng3d.animators.states.AnimationState;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.IRenderable;
	import me.feng3d.core.proxy.Context3DCache;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.entities.Mesh;
	import me.feng3d.errors.AbstractMethodError;
	import me.feng3d.events.AnimatorEvent;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.library.assets.NamedAssetBase;

	/**
	 * 动画基类
	 * @author warden_feng 2014-5-27
	 */
	public class Animator extends NamedAssetBase implements IAsset
	{
		/** 动画驱动器 */
		private var _broadcaster:Sprite = new Sprite();
		private var _isPlaying:Boolean;
		private var _autoUpdate:Boolean = true;
		private var _startEvent:AnimatorEvent;
		private var _cycleEvent:AnimatorEvent;
		/** 当前动画时间 */
		private var _time:int;
		private var _playbackSpeed:Number = 1;

		protected var _animationSet:AnimationSet;
		protected var _owners:Vector.<Mesh> = new Vector.<Mesh>();
		protected var _activeNode:AnimationNode;
		protected var _activeState:AnimationState;
		protected var _activeAnimationName:String;
		/** 开始播放时间 */
		protected var _absoluteTime:Number = 0;
		private var _animationStates:Dictionary = new Dictionary(true);

		/** 是否更新位置 */
		public var updatePosition:Boolean = true;

		/**
		 * 创建一个动画基类
		 * @param animationSet
		 */
		public function Animator(animationSet:AnimationSet)
		{
			_animationSet = animationSet;
			initBuffers();
		}

		public function get animationSet():AnimationSet
		{
			return _animationSet;
		}

		/**
		 * 激活的状态
		 */
		public function get activeState():AnimationState
		{
			return _activeState;
		}

		/**
		 * 播放速度
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
		 * 开始播放动画
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

			dispatchEvent(_startEvent ||= new AnimatorEvent(AnimatorEvent.START, this));
		}

		/**
		 * 重置动画
		 * @param name 动作名称
		 * @param offset 时间偏移量
		 */
		public function reset(name:String, offset:Number = 0):void
		{
			getAnimationState(_animationSet.getAnimation(name)).offset(offset + _absoluteTime);
		}

		/**
		 * 获取动画状态
		 * @param node 动画节点
		 * @return 动画状态
		 */
		public function getAnimationState(node:AnimationNode):AnimationState
		{
			var className:Class = node.stateClass;

			return _animationStates[node] ||= new className(this, node);
		}

		/**
		 * 驱动动画
		 */
		private function onEnterFrame(event:Event = null):void
		{
			update(getTimer());
		}

		/**
		 * 更新动画
		 * @param time 动画时间
		 */
		public function update(time:int):void
		{
			var dt:Number = (time - _time) * playbackSpeed;

			updateDeltaTime(dt);

			_time = time;
		}

		/**
		 * 更新偏移时间
		 * @param dt
		 */
		protected function updateDeltaTime(dt:Number):void
		{
			_absoluteTime += dt;

			_activeState.update(_absoluteTime);

			if (updatePosition)
				applyPositionDelta();
		}

		/**
		 * 应用位置偏移
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
		 * 抛出周期完成事件
		 */
		public function dispatchCycleEvent():void
		{
			if (hasEventListener(AnimatorEvent.CYCLE_COMPLETE))
				dispatchEvent(_cycleEvent || (_cycleEvent = new AnimatorEvent(AnimatorEvent.CYCLE_COMPLETE, this)));
		}

		/**
		 * 设置渲染状态
		 * @param stage3DProxy
		 * @param renderable
		 * @param vertexConstantOffset
		 * @param vertexStreamOffset
		 * @param camera
		 */
		public function setRenderState(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			throw new AbstractMethodError();
		}

		public function get assetType():String
		{
			return AssetType.ANIMATOR;
		}
		
		protected function initBuffers():void
		{
			
		}
		
		public function collectCache(context3dCache:Context3DCache):void
		{
			
		}
		
		public function releaseCache(context3dCache:Context3DCache):void
		{
			
		}
	}
}

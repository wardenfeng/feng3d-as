package com.cdz.heartBeat
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;

	import me.feng.core.FModuleManager;
	import me.feng.events.heartBeat.HeartBeatModuleData;
	import me.feng.events.heartBeat.HeartBeatModuleEvent;

	/**
	 *
	 * @author cdz 2015-10-28
	 */
	public class HeartBeatManager extends FModuleManager
	{
		/**
		 * 心跳跳字典
		 */
		private var _HeartBeatDic:Dictionary;

		private var _frameEventDriver:Shape = new Shape();

		public function HeartBeatManager()
		{
			init()

			_frameEventDriver.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		/**
		 * @inheritDoc
		 */
		override protected function init():void
		{
			//初始化默认任务集合类型字典
			_HeartBeatDic = new Dictionary();

			addListeners();
		}

		/**
		 * 添加事件监听器
		 */
		private function addListeners():void
		{
			dispatcher.addEventListener(HeartBeatModuleEvent.REGISTER_BEAT_TYPE, registerBeat);

			dispatcher.addEventListener(HeartBeatModuleEvent.UNREGISTER_BEAT_TYPE, unregisterBeat);

			dispatcher.addEventListener(HeartBeatModuleEvent.SUSPEND_ONE_BEAT, suspendOne);

			dispatcher.addEventListener(HeartBeatModuleEvent.RESUME_ONE_BEAT, resumeOne);

			dispatcher.addEventListener(HeartBeatModuleEvent.SUSPEND_All_BEAT, suspendAll);

			dispatcher.addEventListener(HeartBeatModuleEvent.RESUME_ALL_BEAT, resumeAll);
		}

		/**
		 * 注册心跳
		 */
		public function registerBeat(e:HeartBeatModuleEvent):void
		{
			var registerData:HeartBeatModuleData = e.data as HeartBeatModuleData;
			if (registerData)
			{
				var beatType:String = registerData.BeatType;
				var beatInterval:Number = registerData.Interval;
				if (_HeartBeatDic == null)
				{
					_HeartBeatDic = new Dictionary;
				}

				if (_HeartBeatDic[beatType] == null)
				{
					var beat:BeatBase = new BeatBase();
					beat.BeatType = beatType;
					beat.setInterval(beatInterval);
					beat.beginBeat();

					_HeartBeatDic[beatType] = beat;
				}
			}
		}

		/**
		 * 注销心跳
		 */
		public function unregisterBeat(e:HeartBeatModuleEvent):void
		{
			var beatType:String = e.data;
			if (beatType != null && beatType != "")
			{
				if (_HeartBeatDic == null)
				{
					return;
				}
				var beat:BeatBase = _HeartBeatDic[beatType];
				beat.dispose();
				_HeartBeatDic[beatType] = null;
			}
		}

		/**
		 * 暂停一个
		 */
		public function suspendOne(e:HeartBeatModuleEvent):void
		{
			var beatType:String = e.data;
			if (beatType != null && beatType != "")
			{
				if (_HeartBeatDic == null)
				{
					return;
				}

				var pHeartBeat:BeatBase = _HeartBeatDic[beatType];
				if (pHeartBeat)
				{
					pHeartBeat.suspend();
				}
			}
		}

		/**
		 * 恢复跳动一个
		 */
		public function resumeOne(e:HeartBeatModuleEvent):void
		{
			var beatType:String = e.data;
			if (beatType != null && beatType != "")
			{
				if (_HeartBeatDic == null)
				{
					return;
				}

				var pHeartBeat:BeatBase = _HeartBeatDic[beatType];
				if (pHeartBeat)
				{
					pHeartBeat.resume();
				}
			}
		}

		/**
		 * 全部暂停
		 */
		public function suspendAll(e:HeartBeatModuleEvent = null):void
		{
			if (_HeartBeatDic)
			{
				for each (var pHeartBeat:BeatBase in _HeartBeatDic)
				{
					if (pHeartBeat)
					{
						pHeartBeat.suspend();
					}
				}
			}
		}

		/**
		 * 恢复跳动
		 */
		public function resumeAll(e:HeartBeatModuleEvent):void
		{
			if (_HeartBeatDic)
			{
				for each (var pHeartBeat:BeatBase in _HeartBeatDic)
				{
					if (pHeartBeat)
					{
						pHeartBeat.resume();
					}
				}
			}
		}

		private function onEnterFrame(e:Event):void
		{
			if (_HeartBeatDic)
			{
				var date:Date = new Date;
				for each (var pHeartBeat:BeatBase in _HeartBeatDic)
				{
					if (pHeartBeat)
					{
						pHeartBeat.beat(date);
					}
				}
			}
		}

	}
}

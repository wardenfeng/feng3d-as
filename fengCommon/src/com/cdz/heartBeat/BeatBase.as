package com.cdz.heartBeat
{
	import flash.events.Event;

	import me.feng.core.GlobalDispatcher;

	/**
	 * 心跳基础类
	 * @author cdz 2015-10-27
	 */
	public class BeatBase
	{

		/**
		 * 心跳类型
		 */
		public var BeatType:String;

		/**
		 * 心跳间隔
		 */
		protected var _beatInterval:Number;

		/**
		 * 上次跳动时间
		 */
		protected var _lastBeatTime:Date;

		private var _isSuspend:Boolean = false;

		public function BeatBase()
		{
			super();
			_beatInterval = 50 / 3; //设置默认时间

		}

		/**
		 * 设置跳动间隔， 毫秒为单位
		 * @param interval 时间间隔
		 *
		 */
		public function setInterval(interval:Number):void
		{
			_beatInterval = interval;
		}

		/**
		 * 开始跳动
		 *
		 */
		public function beginBeat():void
		{
			_lastBeatTime = new Date();
		}

		/**
		 * 心跳
		 * @param nowDate
		 *
		 */
		public function beat(nowDate:Date):void
		{
			if (_isSuspend)
			{
				return;
			}

			var deltaTime:Number = nowDate.getTime() - _lastBeatTime.getTime();
			if (deltaTime >= _beatInterval)
			{
				_lastBeatTime = nowDate;
				GlobalDispatcher.instance.dispatchEvent(new HeartBeatEvent(this.BeatType));
			}
		}

		/**
		 * 挂起
		 */
		public function suspend():void
		{
			_isSuspend = true;
		}

		/**
		 * 恢复
		 */
		public function resume():void
		{
			_isSuspend = false;
		}

		/**
		 * 析构
		 */
		public function dispose():void
		{
			_lastBeatTime = null;
		}
	}
}

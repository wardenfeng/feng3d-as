package com.cdz.heatBeat
{
	import flash.events.Event;

	import com.cdz.heartBeat.HeartBeat;
	import com.cdz.heartBeat.HeartBeatEvent;

	import me.feng.core.GlobalDispatcher;
	import me.feng.events.heartBeat.HeartBeatModuleData;
	import me.feng.events.heartBeat.HeartBeatModuleEvent;

	/**
	 * 测试心跳
	 * @author cdz 2015-10-31
	 */
	public class HeatBeatModuleTest extends TestBase
	{
		public function HeatBeatModuleTest()
		{
		}

		public function init():void
		{
			HeartBeat.init();

			//注册一个渲染心跳
			//HeartBeatModuleData 仅注册心跳时候需要
			//每个心跳都是唯一的，重复注册是无效的
			var heartBeatData:HeartBeatModuleData = new HeartBeatModuleData(HeartBeatEvent.RENDER_BEAT, 1000);
			GlobalDispatcher.instance.dispatchEvent(new HeartBeatModuleEvent(HeartBeatModuleEvent.REGISTER_BEAT_TYPE, heartBeatData));
			GlobalDispatcher.instance.addEventListener(HeartBeatEvent.RENDER_BEAT, onRendBeat);
		}

		private var count:uint = 0;

		/**
		 * 渲染心跳监听， 满十次后挂起渲染心跳，开始逻辑心跳
		 * @param e
		 *
		 */
		public function onRendBeat(e:Event):void
		{
			trace("render beat");
			count++;
			if (count % 10 == 0)
			{
				//暂停事件数据，发送心跳事件类型名就可以了
				trace("suspend render beat");
				GlobalDispatcher.instance.dispatchEvent(new HeartBeatModuleEvent(HeartBeatModuleEvent.SUSPEND_ONE_BEAT, HeartBeatEvent.RENDER_BEAT));

				trace("begin logic beat");
				var heartBeatData:HeartBeatModuleData = new HeartBeatModuleData(HeartBeatEvent.LOGIC_BEAT, 1000);
				GlobalDispatcher.instance.dispatchEvent(new HeartBeatModuleEvent(HeartBeatModuleEvent.REGISTER_BEAT_TYPE, heartBeatData));
				GlobalDispatcher.instance.addEventListener(HeartBeatEvent.LOGIC_BEAT, onLogicBeat);
			}
		}

		/**
		 * 逻辑心跳监听，满十次后恢复渲染心跳并开始物理心跳
		 * @param e
		 *
		 */
		public function onLogicBeat(e:Event):void
		{
			trace("onLogicBeat");
			count++;
			if (count % 10 == 0)
			{
				//恢复某个心跳事件也只要传恢复的心跳类型名即可
				trace("resume render beat");
				GlobalDispatcher.instance.dispatchEvent(new HeartBeatModuleEvent(HeartBeatModuleEvent.RESUME_ONE_BEAT, HeartBeatEvent.RENDER_BEAT));

				trace("begin physics beat");
				var heartBeatData:HeartBeatModuleData = new HeartBeatModuleData(HeartBeatEvent.PHYSICS_BEAT, 1000);
				GlobalDispatcher.instance.dispatchEvent(new HeartBeatModuleEvent(HeartBeatModuleEvent.REGISTER_BEAT_TYPE, heartBeatData));
				GlobalDispatcher.instance.addEventListener(HeartBeatEvent.PHYSICS_BEAT, onPhysicsBeat);
			}
		}

		/**
		 * 物理心跳监听，满十次后关闭所有心跳
		 * @param e
		 *
		 */
		public function onPhysicsBeat(e:Event):void
		{
			trace("onPhysicsBeat");
			count++;
			if (count % 6 == 0)
			{
				//暂停所用事件，不需要额外的其他参数
				trace("suspend All");
				GlobalDispatcher.instance.dispatchEvent(new HeartBeatModuleEvent(HeartBeatModuleEvent.SUSPEND_All_BEAT));
				
				trace("unregister physics beat");
				GlobalDispatcher.instance.dispatchEvent(new HeartBeatModuleEvent(HeartBeatModuleEvent.UNREGISTER_BEAT_TYPE, HeartBeatEvent.PHYSICS_BEAT));
				
				trace("unregister logic beat");
				GlobalDispatcher.instance.dispatchEvent(new HeartBeatModuleEvent(HeartBeatModuleEvent.UNREGISTER_BEAT_TYPE, HeartBeatEvent.LOGIC_BEAT));
				
				trace("begin mouseCheck beat");
				var heartBeatData:HeartBeatModuleData = new HeartBeatModuleData(HeartBeatEvent.MOUSE_CHECK_BEAT, 1000);
				GlobalDispatcher.instance.dispatchEvent(new HeartBeatModuleEvent(HeartBeatModuleEvent.REGISTER_BEAT_TYPE, heartBeatData));
				GlobalDispatcher.instance.addEventListener(HeartBeatEvent.MOUSE_CHECK_BEAT, onMouseCheck);
			}
		}
		
		/**
		 * 鼠标检测心跳监听，十次后恢复所有心跳
		 * 因为渲染心跳被注销，将不会再次启动 
		 * @param e
		 * 
		 */		
		public function onMouseCheck(e:Event):void
		{
			trace("onMouseCheck");
			count++;
			if (count % 5 == 0)
			{
				trace("unregister mouseCheck beat");
				GlobalDispatcher.instance.dispatchEvent(new HeartBeatModuleEvent(HeartBeatModuleEvent.UNREGISTER_BEAT_TYPE, HeartBeatEvent.MOUSE_CHECK_BEAT));
				
				trace("resume All");
				GlobalDispatcher.instance.dispatchEvent(new HeartBeatModuleEvent(HeartBeatModuleEvent.RESUME_ALL_BEAT));
			}
		}
	}
}

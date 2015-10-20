package me.feng.events
{

	//
	// 测试事件调度器
	// @author feng 2014-11-26
	//
	public class FEventDispatcherTest extends TestBase
	{
		public function init():void
		{
			var dispatcher:FEventDispatcher = new FEventDispatcher();
			dispatcher.addEventListener("testEvent", onTestEvent);
			dispatcher.addEventListener("testEvent", onTestEvent);
			dispatcher.dispatchEvent(new FEvent("testEvent"));
		}

		private function onTestEvent(event:FEvent):void
		{
			trace(event.toString());
		}
	}
}

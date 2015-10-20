package me.feng.events
{
	import flash.display.Sprite;

	// 自定义事件内容辅助测试
	// @author feng 2015-2-13
	public class CustomEventContentAssistTest extends TestBase
	{
		public function init():void
		{

			var ad:CustomDispatcher = new CustomDispatcher();
			//.addEventListener( 后会自动提示的事件名称列表中 包括 “test3d”
			//如果 写在该文件外时 会提示 “CustomEvent.TEST”
			ad.addEventListener("test3d", onTest3D);

			var spr:Sprite = new Sprite()
//			spr.addEventListener(
		}

		protected function onTest3D(event:CustomEvent):void
		{
			// TODO Auto-generated method stub

		}
	}
}

import flash.events.Event;
import flash.events.IEventDispatcher;

import me.feng.events.FEventDispatcher;

// sdsd 
[Event(name = "test3d", type = "CustomEvent")]

// sdsfk 
[Event(name = "added", type = "flash.events.Event")]
// sdsfk1 
[Event(name = "activate", type = "flash.events.Event")]

class CustomDispatcher extends FEventDispatcher implements IEventDispatcher
{
	public function CustomDispatcher()
	{
	}
}

class CustomEvent extends Event
{
	public static const TEST:String = "test3d";

	public function CustomEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
}

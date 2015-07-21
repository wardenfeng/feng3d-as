package me.feng.events
{

	//
	// 事件冒泡测试(使用接口)
	// @author warden_feng 2014-11-26
	//
	public class EventBubblesTest2 extends TestBase
	{
		public var a:Container = new Container("a");
		public var b:Container = new Container("b");
		public var c:Container = new Container("c");

		public function init():void
		{
			a.addChild(b);
			b.addChild(c);
			a.addEventListener("testEvent", onTestEvent);
			b.addEventListener("testEvent", onTestEvent);
			c.addEventListener("testEvent", onTestEvent);

			//			a.dispatchEvent(new FEvent("testEvent", null, true));
			//			b.dispatchEvent(new FEvent("testEvent", null, true));
			c.dispatchEvent(new FEvent("testEvent", null, true));
		}

		private function onTestEvent(event:FEvent):void
		{
			trace(event, event.target, event.currentTarget);
		}
	}
}
import flash.events.Event;
import flash.events.IEventDispatcher;

import me.feng.events.FEventDispatcher;

class Container implements IEventDispatcher
{
	// 使用于冒泡 
	public var parent:Container;

	private var _name:String;
	private var dispatcher:FEventDispatcher;

	public function Container(name:String):void
	{
		_name = name;
		dispatcher = new FEventDispatcher(this);
	}

	public function addChild(container:Container):void
	{
		container.parent = this;
	}

	public function toString():String
	{
		return _name;
	}

	public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
	{
		dispatcher.addEventListener(type, listener);
	}

	public function dispatchEvent(event:Event):Boolean
	{
		return dispatcher.dispatchEvent(event);
	}

	public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
	{
		dispatcher.removeEventListener(type, listener);
	}

	public function hasEventListener(type:String):Boolean
	{
		return dispatcher.hasEventListener(type);
	}


	public function willTrigger(type:String):Boolean
	{
		// TODO Auto Generated method stub
		return false;
	}
}

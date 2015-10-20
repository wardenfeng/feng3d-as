package me.feng.events
{
	import flash.events.IEventDispatcher;

	//
	// 测试事件调度器接口
	// @author feng 2014-11-26
	//
	public class IFEventDispatcherTest extends TestBase
	{
		public function init():void
		{
			var dispatcher:IEventDispatcher = new DecoratedDispatcher();
			dispatcher.addEventListener("doSomething", didSomething);
			dispatcher.dispatchEvent(new FEvent("doSomething"));
		}

		public function didSomething(evt:FEvent):void
		{
			trace(evt.toString());
		}
	}
}

import flash.events.Event;
import flash.events.IEventDispatcher;

import me.feng.events.FEventDispatcher;

[Event(name = "added", type = "flash.events.Event")]

class DecoratedDispatcher implements IEventDispatcher
{
	private var dispatcher:FEventDispatcher;

	public function DecoratedDispatcher()
	{
		dispatcher = new FEventDispatcher(this);
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
		return dispatcher.willTrigger(type);
	}
}

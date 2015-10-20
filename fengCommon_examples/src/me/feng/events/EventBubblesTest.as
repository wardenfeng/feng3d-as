package me.feng.events
{

	//
	// 事件冒泡测试
	// @author feng 2014-11-26
	//
	public class EventBubblesTest extends TestBase
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

//			a.addEventListener("testEvent", onTestEvent1);
//			b.addEventListener("testEvent", onTestEvent1);
//			c.addEventListener("testEvent", onTestEvent1);

//			a.dispatchEvent(new FEvent("testEvent", null, true));
//			b.dispatchEvent(new FEvent("testEvent", null, true));
			c.dispatchEvent(new FEvent("testEvent", null, true));
		}

		private function onTestEvent(event:FEvent):void
		{
			trace(event, event.target, event.currentTarget);

			//测试事件停止函数
//			if (event.currentTarget == b)
//				event.stopPropagation();

			//测试事件停止函数
//			if (event.currentTarget == b)
//				event.stopImmediatePropagation();
		}

		private function onTestEvent1(event:FEvent):void
		{
			trace(event, event.target, event.currentTarget);

			//测试事件停止函数
			if (event.currentTarget == b)
				event.stopImmediatePropagation();
		}
	}
}
import me.feng.events.FEventDispatcher;

class Container extends FEventDispatcher
{
	public var parent:Container;

	public function Container(name:String):void
	{
		this.name = name;
	}

	public function addChild(container:Container):void
	{
		container.parent = this;
	}

	public function toString():String
	{
		return name;
	}
}

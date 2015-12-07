package me.feng.events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * 被添加到组件容器后触发
	 */
	[Event(name = "errorEvent", type = "me.feng.events.FErrorEvent")]

	/**
	 * 实现能在非flash原生显示列表中的冒泡的事件适配器.
	 * <p>事件过程使用原生事件机制，不过增强了冒泡功能，使得事件会向上级（默认parent）冒泡。</p>
	 *
	 * @includeExample CustomEventContentAssistTest.as
	 * @includeExample EventBubblesTest.as
	 * @includeExample EventBubblesTest2.as
	 * @includeExample FEventDispatcherTest.as
	 * @includeExample IFEventDispatcherTest.as
	 *
	 * @author feng 2014-5-7
	 */
	public class FEventDispatcher implements IEventDispatcher
	{
		/**
		 * 冒泡属性名称，或者称为上级（默认为parent）
		 */
		public static const BUBBLE_PROPERTY:String = "parent";

		private var dispatcher:IEventDispatcher;

		protected var _name:String;

		/**
		 * 创建 FEventDispatcher 类的实例.
		 *
		 * <p>FEventDispatcher 类通常用作基类，这意味着大多数开发人员都无需使用此构造函数。但是，实现 IEventDispatcher 接口的高级开发人员则需要使用此构造函数。如果您无法扩展 EventDispatcher 类并且必须实现 IEventDispatcher 接口，请使用此构造函数来聚合 EventDispatcher 类的实例。</p>
		 *
		 * @param target		 (default = null) — 调度到 EventDispatcher 对象的事件的目标对象。当 EventDispatcher 实例由实现 IEventDispatcher 的类聚合时，使用此参数；此参数是必需的，以便包含对象可以是事件的目标。请勿在类扩展了 EventDispatcher 的简单情况下使用此参数。
		 *
		 * @see flash.events.EventDispatcher.EventDispatcher()
		 */
		public function FEventDispatcher(target:IEventDispatcher = null)
		{
			if (target != null)
				dispatcher = new EventDispatcher(target);
			else
				dispatcher = new EventDispatcher(this);
		}

		/**
		 * 名称
		 */
		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		/**
		 * 使用 EventDispatcher 对象注册事件侦听器对象，以使侦听器能够接收事件通知. 可以为特定类型的事件、阶段和优先级在显示列表中的所有节点上注册事件侦听器。
		 *
		 * <p>成功注册一个事件侦听器后，无法通过额外调用 addEventListener() 来更改其优先级。要更改侦听器的优先级，必须首先调用 removeListener()。然后，可以使用新的优先级再次注册该侦听器。 </p>
		 * <p>请记住，注册该侦听器后，如果继续调用具有不同 type 或 useCapture 值的 addEventListener()，则会创建单独的侦听器注册。例如，如果首先注册 useCapture 设置为 true 的侦听器，则该侦听器只在捕获阶段进行侦听。如果使用同一个侦听器对象再次调用 addEventListener()，并将 useCapture 设置为 false，那么便会拥有两个单独的侦听器：一个在捕获阶段进行侦听，另一个在目标和冒泡阶段进行侦听。 </p>
		 * <p>不能只为目标阶段或冒泡阶段注册事件侦听器。这些阶段在注册期间是成对出现的，因为冒泡阶段只适用于目标节点的祖代。</p>
		 * <p>如果不再需要某个事件侦听器，可调用 removeEventListener() 删除它，否则会产生内存问题。事件侦听器不会自动从内存中删除，因为只要调度对象存在，垃圾回收器就不会删除侦听器（除非 useWeakReference 参数设置为 true）。</p>
		 * <p>复制 EventDispatcher 实例时并不复制其中附加的事件侦听器。（如果新近创建的节点需要一个事件侦听器，必须在创建该节点后附加该侦听器。）但是，如果移动 EventDispatcher 实例，则其中附加的事件侦听器也会随之移动。</p>
		 * <p>如果在正在处理事件的节点上注册事件侦听器，则不会在当前阶段触发事件侦听器，但会在事件流的稍后阶段触发，如冒泡阶段。</p>
		 * <p>如果从正在处理事件的节点中删除事件侦听器，则该事件侦听器仍由当前操作触发。删除事件侦听器后，决不会再次调用该事件侦听器（除非再次注册以备将来处理）。 </p>
		 * <P>类级别成员函数不属于垃圾回收的对象，因此可以对类级别成员函数将 useWeakReference 设置为 true 而不会使它们受垃圾回收的影响。如果对作为嵌套内部函数的侦听器将 useWeakReference 设置为 true，则该函数将作为垃圾回收并且不再是永久函数。如果创建对该内部函数的引用（将该函数保存到另一个变量中），则该函数将不作为垃圾回收并仍将保持永久。</P>
		 *
		 * @param type						事件的类型。
		 * @param listener					处理事件的侦听器函数。此函数必须接受 Event 对象作为其唯一的参数，并且不能返回任何结果，如下面的实例所示： <pre>function(evt:Event):void</pre>函数可以有任何名称。
		 * @param useCapture				确定侦听器是运行于捕获阶段还是运行于目标和冒泡阶段。如果将 useCapture 设置为 true，则侦听器只在捕获阶段处理事件，而不在目标或冒泡阶段处理事件。如果 useCapture 为 false，则侦听器只在目标或冒泡阶段处理事件。要在所有三个阶段都侦听事件，请调用 addEventListener 两次：一次将 useCapture 设置为 true，一次将 useCapture 设置为 false。
		 * @param priority					事件侦听器的优先级。优先级由一个带符号的 32 位整数指定。数字越大，优先级越高。优先级为 n 的所有侦听器会在优先级为 n -1 的侦听器之前得到处理。如果两个或更多个侦听器共享相同的优先级，则按照它们的添加顺序进行处理。默认优先级为 0。
		 * @param useWeakReference			确定对侦听器的引用是强引用，还是弱引用。强引用（默认值）可防止您的侦听器被当作垃圾回收。弱引用则没有此作用。
		 *
		 * @see flash.events.EventDispatcher.addEventListener()
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * 从 EventDispatcher 对象中删除侦听器. 如果没有向 EventDispatcher 对象注册任何匹配的侦听器，则对此方法的调用没有任何效果。
		 *
		 * @param type						事件的类型。
		 * @param listener					要删除的侦听器对象。
		 * @param useCapture				指出是为捕获阶段还是为目标和冒泡阶段注册了侦听器。如果为捕获阶段以及目标和冒泡阶段注册了侦听器，则需要对 removeEventListener() 进行两次调用才能将这两个侦听器删除，一次调用将 useCapture() 设置为 true，另一次调用将 useCapture() 设置为 false。
		 * @see flash.events.EventDispatcher.removeEventListener()
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}

		/**
		 * 将事件调度到事件流中. 事件目标是对其调用 dispatchEvent() 方法的 EventDispatcher 对象。
		 *
		 * @param event						调度到事件流中的 Event 对象。如果正在重新调度事件，则会自动创建此事件的一个克隆。在调度了事件后，其 target 属性将无法更改，因此您必须创建此事件的一个新副本以能够重新调度。
		 * @return 							如果成功调度了事件，则值为 true。值 false 表示失败或对事件调用了 preventDefault()。
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			var result:Boolean = dispatcher.dispatchEvent(event);
			//实现冒泡功能
			var eventTarget:Object = this;
			if (eventTarget != null && event.bubbles && this.hasOwnProperty(BUBBLE_PROPERTY))
			{
				eventTarget = eventTarget[BUBBLE_PROPERTY];
				if (eventTarget is IEventDispatcher)
				{
					result = result && IEventDispatcher(eventTarget).dispatchEvent(event);
				}
			}
			return result;
		}

		/**
		 * 检查 EventDispatcher 对象是否为特定事件类型注册了任何侦听器. 这样，您就可以确定 EventDispatcher 对象在事件流层次结构中的哪个位置改变了对事件类型的处理。要确定特定事件类型是否确实触发了事件侦听器，请使用 willTrigger()。
		 * <p>hasEventListener() 与 willTrigger() 的区别是：hasEventListener() 只检查它所属的对象，而 willTrigger() 检查整个事件流以查找由 type 参数指定的事件。</p>
		 * <p>当从 LoaderInfo 对象调用 hasEventListener() 时，只考虑调用方可以访问的侦听器。</p>
		 *
		 * @param type		事件的类型。
		 * @return 			如果指定类型的侦听器已注册，则值为 true；否则，值为 false。
		 */
		public function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}

		/**
		 * 检查是否用此 EventDispatcher 对象或其任何祖代为指定事件类型注册了事件侦听器. 将指定类型的事件调度给此 EventDispatcher 对象或其任一后代时，如果在事件流的任何阶段触发了事件侦听器，则此方法返回 true。
		 * <p>hasEventListener() 与 willTrigger() 方法的区别是：hasEventListener() 只检查它所属的对象，而 willTrigger() 方法检查整个事件流以查找由 type 参数指定的事件。 </p>
		 * <p>当从 LoaderInfo 对象调用 willTrigger() 时，只考虑调用方可以访问的侦听器。</p>
		 *
		 * @param type		事件的类型。
		 * @return 			如果将会触发指定类型的侦听器，则值为 true；否则，值为 false。
		 */
		public function willTrigger(type:String):Boolean
		{
			return dispatcher.willTrigger(type);
		}

		/**
		 * 抛出错误事件
		 * <p>该函数会抛出 ErrorEvent.ERROR 事件</p>
		 * <p>仅当错误事件被正确处理（FErrorEvent.isProcessed == true）时不会使用throw抛出错误</p>
		 * @see me.feng.events.FErrorEvent
		 *
		 * @author feng 2015-12-7
		 */
		protected function throwEvent(error:Error):void
		{
			var errorEvent:FErrorEvent = new FErrorEvent(FErrorEvent.ERROR_EVENT, error);
			dispatchEvent(errorEvent);
			if (!errorEvent.isProcessed)
				throw error;
		}
	}
}

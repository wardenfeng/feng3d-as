package me.feng.core
{
	import flash.events.Event;

	/**
	 * 模块管理者
	 * <p>负责模块与外部的事件交互</p>
	 * @author feng
	 */
	public class FModuleManager
	{
		/**
		 * 全局事件
		 */
		protected static var dispatcher:GlobalDispatcher = GlobalDispatcher.instance;

		/**
		 * 创建一个模块
		 */
		public function FModuleManager()
		{
		}

		/**
		 * 初始化模块
		 */
		protected function init():void
		{

		}

		/**
		 * 派发全局事件
		 *
		 * @param event						调度到事件流中的 Event 对象。如果正在重新调度事件，则会自动创建此事件的一个克隆。在调度了事件后，其 target 属性将无法更改，因此您必须创建此事件的一个新副本以能够重新调度。
		 * @return 							如果成功调度了事件，则值为 true。值 false 表示失败或对事件调用了 preventDefault()。
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return GlobalDispatcher.instance.dispatchEvent(event);
		}

		/**
		 * 监听全局事件
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
			GlobalDispatcher.instance.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
	}
}

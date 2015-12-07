package me.feng.events
{
	import me.feng.component.event.ComponentEvent;

	/**
	 * 错误事件
	 * <p>为了与flash.events.ErrorEvent区分添加前缀F</p>
	 * @author feng 2015-12-7
	 */
	public class FErrorEvent extends ComponentEvent
	{
		/**
		 * 错误事件
		 */
		public static const ERROR_EVENT:String = "errorEvent";

		/**
		 * 是否已经处理错误
		 */
		public var isProcessed:Boolean;

		public function FErrorEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}

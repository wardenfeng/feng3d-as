package me.feng3d.events
{
	import me.feng.events.FEvent;

	/**
	 * Fagal函数事件
	 * @author warden_feng 2015-8-8
	 */
	public class FagalMathEvent extends FEvent
	{
		/**
		 * Fagal函数追加代码事件
		 */
		public static const FAGALMATHEVENT_APPEND:String = "fagalMathEventAppend";

		/**
		 * 创建一个作为参数传递给事件侦听器的 Event 对象.
		 * @param type 					事件的类型，可以作为 Event.type 访问。
		 * @param code					fagal代码
		 * @param bubbles 				确定 Event 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param cancelable 			确定是否可以取消 Event 对象。默认值为 false。
		 */
		public function FagalMathEvent(type:String, code:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, code, bubbles, cancelable);
		}

		/**
		 * fagal代码
		 */
		public function get code():String
		{
			return data;
		}
	}
}

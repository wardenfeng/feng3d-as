package com.Tevoydes.objectView
{
	import me.feng.events.FEvent;
	
	/**
	 * 模型界面事件
	 * @author Tevoydes 2015-10-30
	 */
	public class ObjectViewEvent extends FEvent
	{
		public static const SHOW_OBJECTVIEW:String = "showObjectView";
		public static const REGISTER:String = "objectViewRegister";
		
		/**
		 * 创建一个作为参数传递给事件侦听器的 Event 对象.
		 * @param type 					事件的类型，可以作为 Event.type 访问。
		 * @param data					事件携带的数据
		 * @param bubbles 				确定 Event 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param cancelable 			确定是否可以取消 Event 对象。默认值为 false。
		 */
		public function ObjectViewEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}

	}
}
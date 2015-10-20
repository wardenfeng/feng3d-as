package me.feng.load
{
	import me.feng.events.FEvent;

	/**
	 * 加载事件
	 * @author feng 2014-7-25
	 */
	public class LoadEvent extends FEvent
	{
		/** 加载资源 */
		public static const LOAD_RESOURCE:String = "loadResource";

		/** 单项资源加载完成 */
		public static const LOAD_SINGLE_COMPLETE:String = "loadSingleComplete";

		/**
		 * 创建一个加载事件。
		 * @param data					加载事件数据
		 * @param type 					事件的类型，可以作为 Event.type 访问。
		 * @param bubbles 				确定 Event 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param cancelable 			确定是否可以取消 Event 对象。默认值为 false。
		 */
		public function LoadEvent(type:String, data:LoadEventData, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}

		/**
		 * 加载事件数据
		 */
		public function get loadEventData():LoadEventData
		{
			return data;
		}
	}
}

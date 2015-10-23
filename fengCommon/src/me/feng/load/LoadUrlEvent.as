package me.feng.load
{
	import me.feng.events.FEvent;
	import me.feng.load.data.LoadTaskItem;

	/**
	 * 加载url事件
	 * @author feng 2015-10-22
	 */
	public class LoadUrlEvent extends FEvent
	{
		/** 单项资源加载完成 */
		public static const LOAD_SINGLE_COMPLETE:String = "loadSingleComplete";

		/** 资源加载完成 */
		public static const LOAD_COMPLETE:String = "loadComplete";

		/**
		 * 创建一个加载事件。
		 * @param data					加载事件数据
		 * @param type 					事件的类型，可以作为 Event.type 访问。
		 * @param bubbles 				确定 Event 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param cancelable 			确定是否可以取消 Event 对象。默认值为 false。
		 */
		public function LoadUrlEvent(type:String, data:LoadTaskItem = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}

		/**
		 * 加载事件数据
		 */
		public function get loadTaskItem():LoadTaskItem
		{
			return data;
		}
	}
}

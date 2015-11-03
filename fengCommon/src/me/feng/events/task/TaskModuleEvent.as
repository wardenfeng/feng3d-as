package me.feng.events.task
{
	import me.feng.events.FEvent;

	/**
	 * 任务模块事件
	 * @author feng 2015-10-29
	 */
	public class TaskModuleEvent extends FEvent
	{
		/** 派发任务 */
		public static const DISPATCH_TASK:String = "dispatchTask";

		/** 注册任务集合类型 */
		public static const REGISTER_TASKCOLLECTIONTYPE:String = "registerTaskCollectionType";

		/**
		 * 创建任务模块事件
		 * @param type 					事件的类型
		 * @param data					事件携带的数据
		 * @param bubbles 				确定 Event 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param cancelable 			确定是否可以取消 Event 对象。默认值为 false。
		 */
		public function TaskModuleEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}

package me.feng.task
{
	import me.feng.events.FEvent;

	/**
	 * 任务事件
	 * @author feng 2014-7-24
	 */
	public class TaskEvent extends FEvent
	{
		/** 完成任务 */
		public static const COMPLETED:String = "completed";

		/** 完成一个任务单元 */
		public static const COMPLETEDITEM:String = "completedItem";

		/**
		 * 创建任务事件
		 * @param data					事件携带的数据
		 * @param type 					事件的类型
		 * @param bubbles 				确定 Event 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param cancelable 			确定是否可以取消 Event 对象。默认值为 false。
		 */
		public function TaskEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}

package me.feng.events.task
{
	import me.feng.events.FEventDispatcher;
	import me.feng.task.TaskItem;
	import me.feng.task.type.TaskCollectionType;

	/**
	 * 完成一个任务单元时触发
	 * @eventType me.feng.events.TaskEvent
	 */
	[Event(name = "completedItem", type = "me.feng.task.TaskEvent")]

	/**
	 * 完成任务时触发
	 * @eventType me.feng.events.TaskEvent
	 */
	[Event(name = "completed", type = "me.feng.task.TaskEvent")]

	/**
	 * 任务模块事件数据
	 * @author feng 2015-10-29
	 */
	public class TaskModuleEventDispatchTaskData extends FEventDispatcher
	{
		/**
		 * 任务集合类型
		 */
		public var taskCollectionType:String;

		/**
		 * 任务列表
		 */
		public var taskList:Vector.<TaskItem>;

		/**
		 * 任务执行参数
		 */
		public var params:*;

		public function TaskModuleEventDispatchTaskData(taskList:Vector.<TaskItem> = null, taskCollectionType:String = TaskCollectionType.LIST, params:* = null)
		{
			this.taskList = taskList;
			this.taskCollectionType = taskCollectionType;
			this.params = params;
		}
	}
}

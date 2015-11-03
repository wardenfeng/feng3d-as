package me.feng.events.task
{

	/**
	 * 任务模块事件注册任务类型数据
	 * @author feng 2015-10-30
	 */
	public class TaskModuleEventRegisterData
	{
		/**
		 * 任务集合类型名称
		 * @see me.feng.task.type.TaskCollectionType
		 */
		public var taskCollectionType:String;

		/**
		 * 任务集合类型定义
		 */
		public var taskCollectionTypeClass:Class;

		/**
		 *
		 * @param taskCollectionType			任务集合类型名称
		 * @param taskCollectionTypeClass		任务集合类型定义
		 */
		public function TaskModuleEventRegisterData(taskCollectionType:String, taskCollectionTypeClass:Class)
		{
			this.taskCollectionType = taskCollectionType;
			this.taskCollectionTypeClass = taskCollectionTypeClass;
		}
	}
}

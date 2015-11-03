package me.feng.task
{
	import flash.utils.Dictionary;

	import me.feng.core.FModuleManager;
	import me.feng.debug.assert;
	import me.feng.events.task.TaskModuleEvent;
	import me.feng.events.task.TaskModuleEventDispatchTaskData;
	import me.feng.events.task.TaskModuleEventRegisterData;
	import me.feng.task.type.TaskCollectionType;
	import me.feng.task.type.TaskList;
	import me.feng.task.type.TaskQueue;

	/**
	 * 任务模块管理类
	 * @author feng 2015-10-29
	 */
	public class TaskManager extends FModuleManager
	{
		/**
		 * 任务集合类型字典（任务类型名称：任务类型定义）
		 */
		private var taskCollectionTypeDic:Dictionary;

		/**
		 * 执行中的任务集合字典（执行中的任务集合实例：任务相关数据）
		 */
		private var executingTaskCollectionDic:Dictionary;

		/**
		 * 创建一个任务管理器
		 */
		public function TaskManager()
		{
			init();
		}

		/**
		 * @inheritDoc
		 */
		override protected function init():void
		{
			//初始化默认任务集合类型字典
			taskCollectionTypeDic = new Dictionary();
			executingTaskCollectionDic = new Dictionary();

			registerTaskCollectionType(TaskCollectionType.LIST, TaskList);
			registerTaskCollectionType(TaskCollectionType.QUEUE, TaskQueue);

			addListeners();
		}

		/**
		 * 注册任务集合类型
		 * @param taskCollectionType			任务类型名称
		 * @param taskCollectionTypeClass		任务类型定义
		 */
		private function registerTaskCollectionType(taskCollectionType:String, taskCollectionTypeClass:Class):void
		{
			taskCollectionTypeDic[taskCollectionType] = taskCollectionTypeClass;
		}

		/**
		 * 添加事件监听器
		 */
		private function addListeners():void
		{
			dispatcher.addEventListener(TaskModuleEvent.DISPATCH_TASK, onDispatchTask);

			dispatcher.addEventListener(TaskModuleEvent.REGISTER_TASKCOLLECTIONTYPE, onRegisterTaskCollectionType);
		}

		protected function onRegisterTaskCollectionType(event:TaskModuleEvent):void
		{
			var data:TaskModuleEventRegisterData = event.data;
			registerTaskCollectionType(data.taskCollectionType, data.taskCollectionTypeClass);
		}

		/**
		 * 处理派发的任务事件
		 */
		protected function onDispatchTask(event:TaskModuleEvent):void
		{
			var data:TaskModuleEventDispatchTaskData = event.data;

			var taskCollectionCls:Class = taskCollectionTypeDic[data.taskCollectionType];
			assert(taskCollectionCls != null, "尝试使用未注册的（" + data.taskCollectionType + "）任务集合类型");

			var taskCollection:TaskCollection = new taskCollectionCls();
			executingTaskCollectionDic[taskCollection] = data;

			taskCollection.addEventListener(TaskEvent.COMPLETEDITEM, onCompletedItem);
			taskCollection.addEventListener(TaskEvent.COMPLETED, onCompleted);

			taskCollection.addItems(data.taskList);
			taskCollection.execute(data.params);

		}

		/**
		 * 处理完成任务事件
		 */
		protected function onCompleted(event:TaskEvent):void
		{
			var taskCollection:TaskCollection = event.currentTarget as TaskCollection;
			var data:TaskModuleEventDispatchTaskData = executingTaskCollectionDic[taskCollection];
			data.dispatchEvent(event);

			taskCollection.removeEventListener(TaskEvent.COMPLETEDITEM, onCompletedItem);
			taskCollection.removeEventListener(TaskEvent.COMPLETED, onCompleted);

			delete executingTaskCollectionDic[taskCollection];
		}

		/**
		 * 处理完成单个任务事件
		 */
		protected function onCompletedItem(event:TaskEvent):void
		{
			var taskCollection:TaskCollection = event.currentTarget as TaskCollection;
			var data:TaskModuleEventDispatchTaskData = executingTaskCollectionDic[taskCollection];

			data.dispatchEvent(event);
		}

	}
}

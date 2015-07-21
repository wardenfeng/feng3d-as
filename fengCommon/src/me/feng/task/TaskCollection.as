package me.feng.task
{
	import me.feng.error.AbstractClassError;
	import me.feng.events.TaskEvent;

	/**
	 * 完成一个任务单元时触发
	 * @eventType me.feng.events.TaskEvent
	 */
	[Event(name = "completedItem", type = "me.feng.events.TaskEvent")]

	/**
	 * 任务集合，任务列表与任务队列等的基类
	 * @author warden_feng 2015-6-16
	 */
	public class TaskCollection extends TaskItem
	{
		/**
		 * 所有子任务
		 */
		protected var allItemList:Vector.<TaskItem>;

		/**
		 * 排队中的任务
		 * <p>等待执行中的任务</p>
		 */
		protected var waitingItemList:Vector.<TaskItem>;

		/**
		 * 进行中的任务
		 */
		protected var executingItemList:Vector.<TaskItem>;

		/**
		 * 已完成任务列表
		 */
		protected var completedItemList:Vector.<TaskItem>;

		/**
		 * 是否已经结束任务
		 */
		public function get isComplete():Boolean
		{
			return completedItemList.length == allItemList.length;
		}

		/**
		 * 创建一个任务集合
		 * <p>该类为抽象类，无法直接被实例化，请使用其子类</p>
		 */
		public function TaskCollection()
		{
			AbstractClassError.check(this);
			allItemList = new Vector.<TaskItem>();
			executingItemList = new Vector.<TaskItem>();
			completedItemList = new Vector.<TaskItem>();
			super();
		}

		/**
		 * @inheritDoc
		 */
		override public function execute(params:* = null):void
		{
			_state = TaskState.STATE_EXECUTING;
			waitingItemList = allItemList.concat();
			executingItemList.length = 0;
			completedItemList.length = 0;

			//判断是否已经完成任务
			if (isComplete)
			{
				doComplete();
				return;
			}
		}

		/**
		 * 执行子任务
		 * @param taskItem	子任务
		 * @param params	执行参数
		 */
		protected function executeItem(taskItem:TaskItem, params:*):void
		{
			executingItemList.push(taskItem);
			taskItem.execute(params);
		}

		/**
		 * 添加子任务
		 */
		public function addItem(item:TaskItem):void
		{
			if (allItemList.indexOf(item) == -1)
			{
				allItemList.push(item);
				item.addEventListener(TaskEvent.COMPLETED, onCompletedItem);

				if (state == TaskState.STATE_EXECUTING)
				{
					if (item.state == TaskState.STATE_INIT || item.state == TaskState.STATE_EXECUTING)
					{
						executingItemList.push(item);
					}
					else if (item.state == TaskState.STATE_COMPLETED)
					{
						completedItemList.push(item);
					}
				}
			}
		}

		/**
		 * 移除子任务
		 */
		public function removeItem(item:TaskItem):void
		{
			var index:int;
			index = allItemList.indexOf(item);
			if (index != -1)
			{
				allItemList.splice(index, 1);
				item.removeEventListener(TaskEvent.COMPLETED, onCompletedItem);
			}
			index = executingItemList.indexOf(item);
			if (index != -1)
			{
				executingItemList.splice(index, 1);
			}
			index = completedItemList.indexOf(item);
			if (index != -1)
			{
				completedItemList.splice(index, 1);
			}
		}

		/**
		 * 移除所有子任务
		 */
		public function removeAllItem():void
		{
			var item:TaskItem;
			while (allItemList.length > 0)
			{
				item = allItemList.pop();
				item.removeEventListener(TaskEvent.COMPLETED, onCompletedItem);
				item.destroy();
			}
			waitingItemList.length = 0;
			executingItemList.length = 0;
			completedItemList.length = 0;
		}

		/**
		 * 处理子任务完成事件
		 */
		protected function onCompletedItem(event:TaskEvent):void
		{
			var taskItem:TaskItem = event.currentTarget as TaskItem;
			var index:int = executingItemList.indexOf(taskItem);
			if (index != -1)
			{
				executingItemList.splice(index, 1);
			}
			else
				throw new Error("怎么会找不到" + taskItem + "呢？");

			completedItemList.push(taskItem);

			dispatchEvent(new TaskEvent(TaskEvent.COMPLETEDITEM, taskItem));

			checkComplete();
		}

		/**
		 * 检查是否完成任务
		 */
		protected function checkComplete():void
		{
			if (isComplete)
			{
				doComplete();
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			super.destroy();
			removeAllItem();
			allItemList = null;
			waitingItemList = null;
			executingItemList = null;
			completedItemList = null;
		}
	}
}

package me.feng.task
{
	import me.feng.events.TaskEvent;

	/**
	 * 任务队列（按先后顺序依次完成子任务，只有完成当前任务才会开始下个任务）
	 * @includeExample TaskQueueTest.as
	 * @includeExample KeyDownTask.as
	 * @author warden_feng 2015-6-17
	 */
	public class TaskQueue extends TaskCollection
	{
		/**
		 * 执行参数
		 */
		private var executeParams:*;

		/**
		 * 创建任务队列
		 */
		public function TaskQueue()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		override public function execute(params:* = null):void
		{
			super.execute(params);

			executeParams = params;

			executeNextTask();
		}

		/**
		 * 执行下个任务
		 */
		protected function executeNextTask():void
		{
			if (waitingItemList.length > 0)
			{
				var taskItem:TaskItem = waitingItemList.shift();
				executeItem(taskItem, executeParams);
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function onCompletedItem(event:TaskEvent):void
		{
			super.onCompletedItem(event);

			executeNextTask();
		}
	}
}

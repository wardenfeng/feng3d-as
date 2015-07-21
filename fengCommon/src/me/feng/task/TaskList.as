package me.feng.task
{


	/**
	 * 任务列表
	 * <p>所有子任务将会在同一时间开始执行</p>
	 * @includeExample TaskListTest.as
	 * @includeExample KeyDownTask.as
	 *
	 * @author warden_feng 2014-7-24
	 */
	public class TaskList extends TaskCollection
	{
		/**
		 * 创建一个任务队列
		 */
		public function TaskList()
		{
			super();
		}

		/**
		 * 执行任务
		 * @param params	执行参数
		 */
		override public function execute(params:* = null):void
		{
			super.execute(params);

			//执行所有子任务
			for (var i:int = 0; i < waitingItemList.length; i++)
			{
				executeItem(waitingItemList[i], params);
			}
			waitingItemList.length = 0;
		}
	}
}

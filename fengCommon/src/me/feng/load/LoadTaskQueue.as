package me.feng.load
{
	import br.com.stimuli.loading.BulkLoader;

	import me.feng.arcaneCommon;
	import me.feng.events.TaskEvent;
	import me.feng.load.data.LoadTaskItem;
	import me.feng.task.TaskList;

	use namespace arcaneCommon;

	/**
	 * 加载任务队列
	 * @author warden_feng 2014-7-25
	 */
	public class LoadTaskQueue extends TaskList
	{
		/** 加载事件数据 */
		private var _loadData:LoadEventData;

		/**
		 * 创建一个加载队列
		 * @param loadData	需要加载的数据
		 * @param loader 	加载器
		 */
		public function LoadTaskQueue(loadData:LoadEventData, loader:BulkLoader)
		{
			super();

			_loadData = loadData;

			addEventListener(TaskEvent.COMPLETED, onComplete);

			var loadItemData:LoadTaskItem;
			for each (var url:Object in loadData.urls)
			{
				loadItemData = new LoadTaskItem(url);
				addItem(loadItemData);
			}

			execute(loader);
		}

		/**
		 * 处理加载任务完成事件
		 */
		protected function onComplete(event:TaskEvent):void
		{
			_loadData.doAllItemsLoaded();
		}

		/**
		 * 处理子加载任务完成事件
		 */
		override protected function onCompletedItem(event:TaskEvent):void
		{
			var taskItemData:LoadTaskItem = event.currentTarget as LoadTaskItem;
			_loadData.doSingleComplete(taskItemData);

			super.onCompletedItem(event);
		}

	}
}

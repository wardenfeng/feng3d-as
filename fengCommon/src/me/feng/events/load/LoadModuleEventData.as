package me.feng.events.load
{
	import me.feng.arcaneCommon;
	import me.feng.events.FEventDispatcher;
	import me.feng.events.task.TaskModuleEventDispatchTaskData;
	import me.feng.load.data.LoadTaskItem;
	import me.feng.task.TaskEvent;
	import me.feng.task.TaskItem;
	import me.feng.task.type.TaskCollectionType;
	import me.feng.load.LoadUrlEvent;

	use namespace arcaneCommon;

	/**
	 * 完成一个任务单元时触发
	 * @eventType me.feng.load.LoadUrlEvent
	 */
	[Event(name = "loadSingleComplete", type = "me.feng.load.LoadUrlEvent")]

	/**
	 * 资源加载完成
	 * @eventType me.feng.load.LoadUrlEvent
	 */
	[Event(name = "loadComplete", type = "me.feng.load.LoadUrlEvent")]

	/**
	 * 加载事件数据
	 * @author feng 2015-5-27
	 */
	public class LoadModuleEventData extends FEventDispatcher
	{
		private var _urls:Array;

		/**
		 * 自定义数据，可用于保存数据在加载资源后处理
		 */
		public var data:Object;

		private var _taskModuleEventData:TaskModuleEventDispatchTaskData;

		/**
		 * 加载事件数据
		 * @param urls		加载路径列表
		 * @param data		自定义数据，可用于保存数据在加载资源后处理
		 */
		public function LoadModuleEventData(urls:Array = null, data:Object = null)
		{
			this.urls = urls;
			this.data = data;
		}

		/**
		 * 加载路径列表
		 */
		public function get urls():Array
		{
			return _urls;
		}

		/**
		 * @private
		 */
		public function set urls(value:Array):void
		{
			_urls = value;
		}

		/**
		 * 加载任务列表
		 * <p>该函数提供给加载模块内部使用，使用者并不需要知道</p>
		 */
		private function get loadTaskItems():Vector.<TaskItem>
		{
			var _loadTaskItems:Vector.<TaskItem> = new Vector.<TaskItem>();

			_loadTaskItems.length = 0;
			for each (var url:Object in urls)
			{
				_loadTaskItems.push(new LoadTaskItem(url));
			}

			return _loadTaskItems;
		}

		/**
		 * 加载任务数据
		 */
		arcaneCommon function get taskModuleEventData():TaskModuleEventDispatchTaskData
		{
			if (_taskModuleEventData == null)
			{
				_taskModuleEventData = new TaskModuleEventDispatchTaskData();
				_taskModuleEventData.addEventListener(TaskEvent.COMPLETEDITEM, onCompletedItem);
				_taskModuleEventData.addEventListener(TaskEvent.COMPLETED, onCompleted);
			}
			_taskModuleEventData.taskList = loadTaskItems;
			_taskModuleEventData.taskCollectionType = TaskCollectionType.QUEUE;

			return _taskModuleEventData;
		}

		/**
		 * 处理完成加载单项事件
		 */
		protected function onCompletedItem(event:TaskEvent):void
		{
			var loadItemData:LoadTaskItem = event.data;
			dispatchEvent(new LoadUrlEvent(LoadUrlEvent.LOAD_SINGLE_COMPLETE, loadItemData));
		}

		/**
		 * 处理完成所有加载项事件
		 */
		private function onCompleted(event:TaskEvent):void
		{
			dispatchEvent(new LoadUrlEvent(LoadUrlEvent.LOAD_COMPLETE));
		}
	}
}

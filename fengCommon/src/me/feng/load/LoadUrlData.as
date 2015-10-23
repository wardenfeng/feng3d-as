package me.feng.load
{
	import me.feng.arcaneCommon;
	import me.feng.events.FEventDispatcher;
	import me.feng.load.data.LoadTaskItem;

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
	public class LoadUrlData extends FEventDispatcher
	{
		/**
		 * 加载路径列表
		 */
		public var urls:Array;

		/**
		 * 自定义数据，可用于保存数据在加载资源后处理
		 */
		public var data:Object;

		/**
		 * 执行单个资源加载完成回调函数
		 * @param loadItemData			加载单元数据
		 */
		arcaneCommon function doSingleComplete(loadItemData:LoadTaskItem):void
		{
			dispatchEvent(new LoadUrlEvent(LoadUrlEvent.LOAD_SINGLE_COMPLETE, loadItemData));
		}

		/**
		 * 执行所有资源加载完成回调函数
		 */
		arcaneCommon function doAllItemsLoaded():void
		{
			dispatchEvent(new LoadUrlEvent(LoadUrlEvent.LOAD_COMPLETE));
		}
	}
}

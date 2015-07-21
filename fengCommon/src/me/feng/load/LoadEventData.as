package me.feng.load
{
	import me.feng.arcaneCommon;
	import me.feng.load.data.LoadTaskItem;

	/**
	 * 加载事件数据
	 * @author warden_feng 2015-5-27
	 */
	public class LoadEventData
	{
		/**
		 * 加载路径列表
		 */
		public var urls:Array;

		/**
		 * 单个资源加载完成回调函数
		 */
		public var singleComplete:Function;

		/**
		 * 所有资源加载完成回调函数
		 */
		public var allItemsLoaded:Function;

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
			singleComplete && singleComplete(this, loadItemData);
		}

		/**
		 * 执行所有资源加载完成回调函数
		 */
		arcaneCommon function doAllItemsLoaded():void
		{
			allItemsLoaded && allItemsLoaded(this);
		}
	}
}

package me.feng.load.data
{
	import flash.events.Event;

	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	import me.feng.task.TaskItem;

	/**
	 * 加载单元数据
	 * @author feng 2015-5-27
	 */
	public class LoadTaskItem extends TaskItem
	{
		private var _url:String;
		private var _type:String;
		private var _loadingItem:LoadingItem;

		/**
		 * 创建一个加载单元数据
		 * @param url		加载路径信息
		 */
		public function LoadTaskItem(url:*)
		{
			_url = null;
			_type = null;
			if (url is String)
			{
				_url = url;
			}
			else
			{
				_type = url.type;
				_url = url.url;
			}
		}

		/**
		 * 单项资源加载器
		 */
		public function get loadingItem():LoadingItem
		{
			return _loadingItem;
		}

		/**
		 * 资源类型
		 */
		public function get type():String
		{
			return _type;
		}

		/**
		 * 资源路径
		 */
		public function get url():String
		{
			return _url;
		}

		/**
		 * @inheritDoc
		 */
		override public function execute(param:* = null):void
		{
			var loader:BulkLoader = param;
			//加载资源
			if (!loader.hasItem(_url))
			{
				if (_type)
				{
					loader.add(_url, {type: _type});
				}
				else
				{
					loader.add(_url);
				}
			}

			_loadingItem = loader.get(_url);
			if (_loadingItem.isLoaded)
			{
				doComplete();
			}
			else
			{
				_loadingItem.addEventListener(BulkLoader.COMPLETE, onLoadComplete);
			}
		}

		/**
		 * 完成任务事件
		 */
		private function onLoadComplete(event:Event = null):void
		{
			_loadingItem.removeEventListener(BulkLoader.COMPLETE, onLoadComplete);

			doComplete();
		}

	}
}

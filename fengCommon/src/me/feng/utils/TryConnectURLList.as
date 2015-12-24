package me.feng.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * 尝试获取可连接地址
	 * @author feng 2015-12-15
	 */
	public class TryConnectURLList extends EventDispatcher
	{
		private var urls:Array;
		public var connectedUrls:Array;

		public function TryConnectURLList()
		{

		}

		public static function tryConnect(urls:Array, resultFunc:Function):TryConnectURLList
		{
			var tryRootPath:TryConnectURLList = new TryConnectURLList();
			tryRootPath.addEventListener(Event.COMPLETE, function(event:Event):void
			{
				var tryRootPath:TryConnectURLList = event.currentTarget as TryConnectURLList;
				resultFunc(tryRootPath.connectedUrls);
			});

			return tryRootPath;
		}

		public function tryConnect(urls:Array):void
		{
			this.urls = urls;
			connectedUrls = [];

			tryConnectNext();
		}

		private function tryConnectNext():void
		{
			if (urls.length == 0)
			{
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}

			var url:String = urls.shift();
			tryConnectSingle(url);
		}

		private function tryConnectSingle(url:String):void
		{
			var tryConnect:TryConnectURL = new TryConnectURL();
			tryConnect.addEventListener(Event.COMPLETE, onTryConnectComplete);
			tryConnect.tryConnect(url);
		}

		protected function onTryConnectComplete(event:Event):void
		{
			var tryConnect:TryConnectURL = event.currentTarget as TryConnectURL;
			if (tryConnect.result)
				connectedUrls.push(tryConnect.url);
			tryConnectNext();
		}
	}
}

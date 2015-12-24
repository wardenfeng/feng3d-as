package me.feng.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * 尝试获取可连接地址
	 * @author feng 2015-12-15
	 */
	public class TryConnectURL extends EventDispatcher
	{
		private var loader:URLLoader;
		public var result:Boolean;
		public var url:String;

		public function tryConnect(url:String):void
		{
			loader = new URLLoader();
			this.url = url;
			addListeners();

			var request:URLRequest = new URLRequest(url);
			try
			{
				loader.load(request);
			}
			catch (error:Error)
			{
				connectFailure();
			}
		}

		private function addListeners():void
		{
			loader.addEventListener(Event.COMPLETE, connectSucceed);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, connectFailure);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}

		private function removeListeners():void
		{
			loader.removeEventListener(Event.COMPLETE, connectSucceed);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, connectFailure);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}

		private function connectFailure(... args):void
		{
			result = false;
			connentEnd();
		}

		private function connectSucceed(... args):void
		{
			result = true;
			connentEnd();
		}

		private function connentEnd():void
		{
			removeListeners();

			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function ioErrorHandler(event:IOErrorEvent):void
		{
			if (loader.bytesLoaded > 0)
			{
				connectSucceed();
			}
			else
			{
				connectFailure();
			}
		}
	}
}

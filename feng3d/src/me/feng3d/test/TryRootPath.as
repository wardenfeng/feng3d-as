package me.feng3d.test
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	/**
	 * 尝试获取可连接地址
	 * @author feng 2015-12-15
	 */
	public class TryRootPath
	{
//		private var videoURL:String = "http://images.feng3d.me/feng3dDemo/assets/";
		private var videoURL:String = "http://127.0.0.1:9080/";

		private var loader:URLLoader;

		public function TryRootPath()
		{
			loader = new URLLoader();
			configureListeners(loader);

			var request:URLRequest = new URLRequest(videoURL);
			try
			{
				loader.load(request);
			}
			catch (error:Error)
			{
				trace("Unable to load requested document.");
			}
		}

		private function configureListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}

		private function completeHandler(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			trace("completeHandler: " + loader.data);

			var vars:URLVariables = new URLVariables(loader.data);
			trace("The answer is " + vars.answer);
		}

		private function openHandler(event:Event):void
		{
			trace("openHandler: " + event);
		}

		private function progressHandler(event:ProgressEvent):void
		{
			trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			trace("securityErrorHandler: " + event);
		}

		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
			trace("httpStatusHandler: " + event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void
		{
			trace("ioErrorHandler: " + event);
		}
	}
}


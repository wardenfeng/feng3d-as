package me.feng.utils
{
	import me.feng.task.TaskEvent;
	import me.feng.task.type.TaskQueue;

	/**
	 * 尝试获取可连接地址
	 * @author feng 2015-12-15
	 */
	public class TryConnectURL extends TaskQueue
	{
		public var connectedUrls:Array;

		public function tryConnect(urls:Array):void
		{
			connectedUrls = [];
			for (var i:int = 0; i < urls.length; i++)
			{
				addItem(new TryConnectURLTaskItem(urls[i]));
			}
			execute();
		}

		/**
		 * @inheritDoc
		 */
		override protected function onCompletedItem(event:TaskEvent):void
		{
			super.onCompletedItem(event);

			var taskItem:TryConnectURLTaskItem = event.target as TryConnectURLTaskItem;
			if (taskItem.result)
			{
				connectedUrls.push(taskItem.url);
			}
		}
	}
}

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import me.feng.task.TaskItem;

/**
 * 尝试获取可连接地址
 * @author feng 2015-12-15
 */
class TryConnectURLTaskItem extends TaskItem
{
	private var loader:URLLoader;
	public var result:Boolean;
	public var url:String;

	public function TryConnectURLTaskItem(url:String)
	{
		this.url = url;
	}

	/**
	 * @inheritDoc
	 */
	override public function execute(param:* = null):void
	{
		tryConnect();
	}

	private function tryConnect():void
	{
		loader = new URLLoader();
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
		loader = null;

		doComplete();
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

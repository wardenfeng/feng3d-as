package me.feng.utils
{
	import flash.display.Sprite;
	import flash.events.Event;

	import me.feng.task.TaskEvent;

	/**
	 *
	 * @author feng 2015-12-15
	 */
	public class TryConnectURLDemo extends Sprite
	{
		public function TryConnectURLDemo()
		{
			var tryRootPath:TryConnectURL = new TryConnectURL();
			tryRootPath.addEventListener(TaskEvent.COMPLETED, tryRootPathComplete);
			tryRootPath.tryConnect([ //
				"http://images.feng3d.me/feng3dDemo/assets/", //
				"http://127.0.0.1:9080/", //
				]);
		}

		protected function tryRootPathComplete(event:Event):void
		{
			var tryRootPath:TryConnectURL = event.currentTarget as TryConnectURL;
			if (tryRootPath.connectedUrls.length == 0)
			{
				trace("没有可连接的资源路径！");
			}
			else
			{
				trace("以下为可连接的资源路径：");
				trace(tryRootPath.connectedUrls);
			}
		}
	}
}

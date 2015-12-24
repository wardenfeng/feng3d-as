package me.feng.utils
{
	import flash.display.Sprite;
	import flash.events.Event;


	/**
	 *
	 * @author feng 2015-12-15
	 */
	public class TryRootPathDemo extends Sprite
	{
		public function TryRootPathDemo()
		{
			var tryRootPath:TryConnectURLList = new TryConnectURLList();
			tryRootPath.addEventListener(Event.COMPLETE, tryRootPathComplete);
			tryRootPath.tryConnect([ //
				"http://images.feng3d.me/feng3dDemo/assets/", //
				"http://127.0.0.1:9080/", //
				]);
		}

		protected function tryRootPathComplete(event:Event):void
		{
			var tryRootPath:TryConnectURLList = event.currentTarget as TryConnectURLList;
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

package me.feng3d.test
{
	import com.junkbyte.console.Cc;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

	import me.feng.core.GlobalDispatcher;
	import me.feng.debug.DebugCommon;
	import me.feng.events.load.LoadModuleEvent;
	import me.feng.events.load.LoadModuleEventData;
	import me.feng.load.Load;
	import me.feng.load.LoadUrlEvent;
	import me.feng.task.Task;
	import me.feng.task.TaskEvent;
	import me.feng.utils.TryConnectURL;
	import me.feng3d.configs.Context3DBufferIDConfig;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 测试基类
	 * @author feng 2014-4-9
	 */
	public class TestBase extends Sprite
	{
		protected var rootPaths:Array = [ //
			"http://127.0.0.1:9080/", //
			"http://images.feng3d.me/feng3dDemo/assets/", //
			];

		//资源根路径
		protected var rootPath:String = "http://127.0.0.1:9080/";

		/**
		 * 资源列表
		 */
		protected var resourceList:Array;

		/** 资源字典 */
		protected var resourceDic:Dictionary;

		public function TestBase()
		{
			initModules();

			tryConnect();
		}

		private function initModules():void
		{
			MyCC.initFlashConsole(this);
			DebugCommon.loggerFunc = Cc.log;
			new ConsoleExtension();

			Task.init();
			Load.init();
		}

		private function tryConnect():void
		{
			var tryRootPath:TryConnectURL = new TryConnectURL();
			tryRootPath.addEventListener(TaskEvent.COMPLETED, tryRootPathComplete);
			tryRootPath.tryConnect(rootPaths);
		}

		private function tryRootPathComplete(event:Event):void
		{
			var tryConnectURL:TryConnectURL = event.currentTarget as TryConnectURL;
			if (tryConnectURL.connectedUrls.length == 0)
			{
				trace("没有可连接的资源路径！");
			}
			else
			{
				trace("以下为可连接的资源路径：");
				trace(tryConnectURL.connectedUrls);
				rootPath = tryConnectURL.connectedUrls[0];
				loadTextures();
			}
		}

		/**
		 * 加载纹理资源
		 */
		private function loadTextures():void
		{
			resourceDic = new Dictionary();

			//加载资源
			var loadObj:LoadModuleEventData = new LoadModuleEventData();
			loadObj.urls = [];
			for (var i:int = 0; resourceList != null && i < resourceList.length; i++)
			{
				if (resourceList[i] is String)
				{
					loadObj.urls.push(rootPath + resourceList[i]);
				}
				else
				{
					resourceList[i].url = rootPath + resourceList[i].url;
					loadObj.urls.push(resourceList[i]);
				}
			}
			loadObj.addEventListener(LoadUrlEvent.LOAD_SINGLE_COMPLETE, singleGeometryComplete);
			loadObj.addEventListener(LoadUrlEvent.LOAD_COMPLETE, allItemsLoaded);
			GlobalDispatcher.instance.dispatchEvent(new LoadModuleEvent(LoadModuleEvent.LOAD_RESOURCE, loadObj));
		}

		/** 单个资源加载完毕 */
		private function singleGeometryComplete(evnet:LoadUrlEvent):void
		{
			var path:String = evnet.loadTaskItem.url;
			path = path.substr(rootPath.length);

			resourceDic[path] = evnet.loadTaskItem.loadingItem.content;
		}

		/**
		 * 处理全部加载完成事件
		 */
		protected function allItemsLoaded(event:LoadUrlEvent):void
		{
			//配置3d缓存编号
			FagalRE.addBufferID(Context3DBufferIDConfig.bufferIdConfigs);

			this["init"]();
		}
	}
}



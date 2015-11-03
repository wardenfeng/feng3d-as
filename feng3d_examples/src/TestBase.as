package
{
	import com.junkbyte.console.Cc;

	import flash.display.Sprite;
	import flash.utils.Dictionary;

	import me.feng.core.GlobalDispatcher;
	import me.feng.debug.DebugCommon;
	import me.feng.events.load.LoadModuleEvent;
	import me.feng.events.load.LoadModuleEventData;
	import me.feng.load.Load;
	import me.feng.load.LoadUrlEvent;
	import me.feng.task.Task;
	import me.feng3d.ConsoleExtension;
	import me.feng3d.configs.Context3DBufferIDConfig;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 *
	 * @author feng 2014-4-9
	 */
	public class TestBase extends Sprite
	{
		//资源根路径
		protected var rootPath:String = "http://images.feng3d.me/feng3dDemo/assets/";

		/**
		 * 资源列表
		 */
		protected var resourceList:Array;

		/** 资源字典 */
		protected var resourceDic:Dictionary;

		public function TestBase()
		{
			initModules();

			loadTextures();
		}

		private function initModules():void
		{
			MyCC.initFlashConsole(this);
			DebugCommon.loggerFunc = Cc.log;
			new ConsoleExtension();

			Task.init();
			Load.init();
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
			if (resourceList != null)
			{
				for (var i:int = 0; i < resourceList.length; i++)
				{
					loadObj.urls.push(rootPath + resourceList[i]);
				}
			}
			loadObj.addEventListener(LoadUrlEvent.LOAD_SINGLE_COMPLETE, singleGeometryComplete);
			loadObj.addEventListener(LoadUrlEvent.LOAD_COMPLETE, allItemsLoaded);
			GlobalDispatcher.instance.dispatchEvent(new LoadModuleEvent(LoadModuleEvent.LOAD_RESOURCE, loadObj));
		}

		/** 单个资源加载完毕 */
		private function singleGeometryComplete(event:LoadUrlEvent):void
		{
			var path:String = event.loadTaskItem.url;
			path = path.substr(rootPath.length);

			resourceDic[path] = event.loadTaskItem.loadingItem.content;
		}

		/**
		 * 处理全部加载完成事件
		 */
		private function allItemsLoaded(event:LoadUrlEvent):void
		{
			//配置3d缓存编号
			FagalRE.addBufferID(Context3DBufferIDConfig.bufferIdConfigs);

			this["init"]();
		}
	}
}

package
{
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;

	import me.feng3d.core.buffer.Context3DCache;
	import me.feng3d.debug.Context3DBufferDebug;

	/**
	 * 测试3D环境缓存类
	 * @author feng 2015-7-1
	 */
	public class Context3DCacheDebugText extends TestBase
	{
		private var debugTextPath:String = "context3DCacheDebug.txt";
//		private var debugTextPath:String = "TestMaterial_context3DBufferDebug.txt";

		private var stage3D:Stage3D;
		private var renderContext:Context3D;
		private var context3DCache:Context3DCache;

		public function Context3DCacheDebugText()
		{
			resourceList = [debugTextPath];
			super();
		}

		/**
		 * Global initialise function
		 */
		public function init():void
		{
			var obj:Object = JSON.parse(resourceDic[debugTextPath]);

			context3DCache = Context3DBufferDebug.getContext3DCache(obj);

			stage3D = this.stage.stage3Ds[0];

			//Add event listener before requesting the context
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, contextCreated);
			stage3D.addEventListener(ErrorEvent.ERROR, contextCreationError);
			stage3D.requestContext3D(Context3DRenderMode.AUTO, Context3DProfile.STANDARD);
		}

		//Note, context3DCreate event can happen at any time, such as when the hardware resources are taken by another process
		private function contextCreated(event:Event):void
		{
			renderContext = Stage3D(event.target).context3D;
			logger("3D driver: " + renderContext.driverInfo);
			setupScene();
		}

		private function setupScene():void
		{
			renderContext.enableErrorChecking = true; //Can slow rendering - only turn on when developing/testing
			renderContext.configureBackBuffer(stage.stageWidth, stage.stageHeight, 2, false);

//			this.stage.addEventListener(Event.ENTER_FRAME, render);
			render(null);
		}

		private function render(event:Event):void
		{
			renderContext.clear(1, 1, 1);

			context3DCache.render(renderContext);

			//Show the frame
			renderContext.present();
		}

		private function contextCreationError(error:ErrorEvent):void
		{
			logger(error.errorID + ": " + error.text);
		}

	}
}

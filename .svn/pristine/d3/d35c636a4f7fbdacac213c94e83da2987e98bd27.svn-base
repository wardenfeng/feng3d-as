package feng3d.containers
{
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.events.Event;
	
	import feng3d.Feng3dData;
	import feng3d.ShaderProgram;
	import feng3d.cameras.Camera3D;
	import feng3d.core.Object3D;
	import feng3d.core.render.Renderer;

	/**
	 *
	 * @author warden_feng 2014-3-17
	 */
	public class View3D extends Sprite
	{
		private var _camera:Camera3D;

		private var _scene:Scene3D;

		// the 3d graphics window on the stage
		private var context3D:Context3D;

		private var _entityCollector:Vector.<Object3D>;

		protected var _renderer:Renderer;

		public function View3D(scene:Scene3D = null, camera:Camera3D = null)
		{
			_scene = scene || new Scene3D();
			_camera = camera || new Camera3D();
			_renderer = new Renderer();
			_renderer.camera = _camera;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}

		public function get camera():Camera3D
		{
			return _camera;
		}

		private function onAddedToStage(event:Event):void
		{
			// and request a context3D from Stage3d
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate);
			stage.stage3Ds[0].requestContext3D();
		}

		private function onContext3DCreate(event:Event):void
		{
			// Obtain the current context
			var t:Stage3D = event.target as Stage3D;
			context3D = t.context3D;

			if (context3D == null)
			{
				// Currently no 3d context is available (error!)
				return;
			}

			// Disabling error checking will drastically improve performance.
			// If set to true, Flash sends helpful error messages regarding
			// AGAL compilation errors, uninitialized program constants, etc.
			context3D.enableErrorChecking = true;

			// The 3d back buffer size is in pixels (2=antialiased)
			context3D.configureBackBuffer(Feng3dData.viewWidth, Feng3dData.viewHeight, 2, true);

			shaderProgram.initShaders(context3D);

			_renderer.context3D = context3D;

			// start the render loop!
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}

		private function enterFrame(e:Event):void
		{
			render();
		}

		public function render():void
		{
			context3D.clear();

			_entityCollector = new Vector.<Object3D>();

			//收集显示对象
			_scene.collectDisplayObject(_entityCollector);

			//渲染显示对象
			_renderer.render(_entityCollector);

			context3D.present();
		}

		/** 3d场景 */
		public function get scene():Scene3D
		{
			return _scene;
		}

		/**
		 * @private
		 */
		public function set scene(value:Scene3D):void
		{
			_scene = value;
		}

		public function get shaderProgram():ShaderProgram
		{
			return Feng3dData.shaderProgram;
		}

		public function set shaderProgram(value:ShaderProgram):void
		{
			Feng3dData.shaderProgram = value;
		}
	}
}

package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;

	import me.feng3d.cameras.Camera3D;
	import me.feng3d.containers.Scene3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.controllers.HoverController;
	import me.feng3d.entities.Mesh;
	import me.feng3d.lights.DirectionalLight;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.materials.lightpickers.StaticLightPicker;
	import me.feng3d.primitives.PlaneGeometry;
	import me.feng3d.utils.Cast;

	/**
	 * 测试方向光
	 * @author feng
	 */
	[SWF(backgroundColor = "#ffffff", frameRate = "60", quality = "LOW", width = "670", height = "380")]
	public class TestDirectionalLight extends TestBase
	{
		//plane textures
		public static var FloorDiffuse:String = "embeds/floor_diffuse.jpg";
		public static var FloorNormals:String = "embeds/floor_normal.jpg";

		//engine variables
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		private var cameraController:HoverController;

		//material objects
		private var planeMaterial:TextureMaterial;

		//light objects
		private var light1:DirectionalLight;
		private var light2:DirectionalLight;
		private var light3:DirectionalLight;
		private var lightPicker:StaticLightPicker;

		//scene objects
		private var plane:Mesh;

		//navigation variables
		private var move:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;

		/**
		 * Constructor
		 */
		public function TestDirectionalLight()
		{
			resourceList = [FloorDiffuse, FloorNormals];
			super();
		}

		/**
		 * Global initialise function
		 */
		public function init():void
		{
			initEngine();
			initLights();
			initMaterials();
			initObjects();
			initListeners();
		}

		/**
		 * Initialise the engine
		 */
		private function initEngine():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			scene = new Scene3D();

			camera = new Camera3D();

			view = new View3D();
			view.scene = scene;
			view.camera = camera;

			//setup controller to be used on the camera
			cameraController = new HoverController(camera);
			cameraController.distance = 1000;
			cameraController.minTiltAngle = 0;
			cameraController.maxTiltAngle = 90;
			cameraController.panAngle = 45;
			cameraController.tiltAngle = 20;

			addChild(view);
		}

		/**
		 * Initialise the materials
		 */
		private function initMaterials():void
		{
			planeMaterial = new TextureMaterial(Cast.bitmapTexture(resourceDic[FloorDiffuse]));
			planeMaterial.normalMap = Cast.bitmapTexture(resourceDic[FloorNormals]);
			planeMaterial.lightPicker = lightPicker;
			planeMaterial.repeat = true;
			planeMaterial.mipmap = false;
			planeMaterial.specular;
			planeMaterial.specularColor;
			planeMaterial.specularMethod;
			planeMaterial.ambient;
			planeMaterial.ambientColor;
			planeMaterial.ambientMethod;
			planeMaterial.diffuseMethod;
		}

		/**
		 * Initialise the lights
		 */
		private function initLights():void
		{
			light1 = new DirectionalLight();
			light1.direction = new Vector3D(0, -1, 0);
			light1.color = 0xff00ff;
			light1.ambient = 0.1;
			light1.diffuse = 0.9;
			light1.specular = 1;

			scene.addChild(light1);

			light2 = new DirectionalLight();
			light2.direction = new Vector3D(1, -1, -1);
			light2.color = 0x00FFFF;
			light2.ambient = 0.1;
			light2.diffuse = 0.9;
			light2.specular = 1;

			scene.addChild(light2);

			light3 = new DirectionalLight();
			light3.direction = new Vector3D(-1, 1, 1);
			light3.color = 0xff0000;
			light3.ambient = 0.1;
			light3.diffuse = 0.9;
			light3.specular = 1;

			scene.addChild(light3);

			lightPicker = new StaticLightPicker([light1, light2, light3]);
//			lightPicker = new StaticLightPicker([light1]);
		}

		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{
			plane = new Mesh(new PlaneGeometry(1000, 1000, 1, 1), planeMaterial);
			plane.geometry.scaleUV(2, 2);
			plane.y = -20;

			scene.addChild(plane);
		}

		/**
		 * Initialise the listeners
		 */
		private function initListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}

		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void
		{
			if (move)
			{
				cameraController.panAngle = 0.3 * (stage.mouseX - lastMouseX) + lastPanAngle;
				cameraController.tiltAngle = 0.3 * (stage.mouseY - lastMouseY) + lastTiltAngle;
			}

			light1.direction = new Vector3D(Math.sin(getTimer() / 10000) * 1500, -1000, Math.cos(getTimer() / 10000) * 1500);
		}

		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(event:MouseEvent):void
		{
			lastPanAngle = cameraController.panAngle;
			lastTiltAngle = cameraController.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			move = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:MouseEvent):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		/**
		 * Mouse stage leave listener for navigation
		 */
		private function onStageMouseLeave(event:Event):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}

		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
	}
}

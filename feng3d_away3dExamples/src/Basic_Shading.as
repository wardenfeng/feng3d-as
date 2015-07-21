package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DProfile;
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
	import me.feng3d.primitives.CubeGeometry;
	import me.feng3d.primitives.PlaneGeometry;
	import me.feng3d.primitives.SphereGeometry;
	import me.feng3d.primitives.TorusGeometry;
	import me.feng3d.textures.BitmapTexture;
	import me.feng3d.utils.Cast;

	[SWF(backgroundColor = "#000000", frameRate = "60", quality = "LOW")]
	public class Basic_Shading extends TestBase
	{
		//cube textures
		public static var TrinketDiffuse:String = "embeds/trinket_diffuse.jpg";
		public static var TrinketSpecular:String = "embeds/trinket_specular.jpg";

		public static var TrinketNormals:String = "embeds/trinket_normal.jpg";

		//sphere textures
		public static var BeachBallDiffuse:String = "embeds/beachball_diffuse.jpg";
		public static var BeachBallSpecular:String = "embeds/beachball_specular.jpg";

		//torus textures
		public static var WeaveDiffuse:String = "embeds/weave_diffuse.jpg";
		public static var WeaveNormals:String = "embeds/weave_normal.jpg";

		//plane textures
		public static var FloorDiffuse:String = "embeds/floor_diffuse.jpg";
		public static var FloorSpecular:String = "embeds/floor_specular.jpg";
		public static var FloorNormals:String = "embeds/floor_normal.jpg";

		//engine variables
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		private var cameraController:HoverController;

		//material objects
		private var planeMaterial:TextureMaterial;
		private var sphereMaterial:TextureMaterial;
		private var cubeMaterial:TextureMaterial;
		private var torusMaterial:TextureMaterial;

		//light objects
		private var light1:DirectionalLight;
		private var light2:DirectionalLight;
		private var lightPicker:StaticLightPicker;

		//scene objects
		private var plane:Mesh;
		private var sphere:Mesh;
		private var cube:Mesh;
		private var torus:Mesh;

		//navigation variables
		private var move:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;

		/**
		 * Constructor
		 */
		public function Basic_Shading()
		{
			resourceList = [TrinketDiffuse, //
				TrinketSpecular, //
				TrinketNormals, //
				BeachBallDiffuse, BeachBallSpecular, WeaveDiffuse, //
				WeaveNormals, FloorDiffuse, FloorSpecular, FloorNormals,];
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

			view = new View3D(null, null, null, false, Context3DProfile.STANDARD);
//			view.antiAlias = 4;
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
//			addChild(new AwayStats(view));
		}

		/**
		 * Initialise the materials
		 */
		private function initMaterials():void
		{
			planeMaterial = new TextureMaterial(Cast.bitmapTexture(resourceDic[FloorDiffuse]));
			planeMaterial.specularMap = Cast.bitmapTexture(resourceDic[FloorSpecular]);
			planeMaterial.normalMap = Cast.bitmapTexture(resourceDic[FloorNormals]);
			planeMaterial.lightPicker = lightPicker;
			planeMaterial.repeat = true;
			planeMaterial.mipmap = false;

			sphereMaterial = new TextureMaterial(Cast.bitmapTexture(resourceDic[BeachBallDiffuse]));
			sphereMaterial.specularMap = Cast.bitmapTexture(resourceDic[BeachBallSpecular]);
			sphereMaterial.lightPicker = lightPicker;

			cubeMaterial = new TextureMaterial(Cast.bitmapTexture(resourceDic[TrinketDiffuse]));
			cubeMaterial.specularMap = Cast.bitmapTexture(resourceDic[TrinketSpecular]);
			cubeMaterial.normalMap = Cast.bitmapTexture(resourceDic[TrinketNormals]);
			cubeMaterial.lightPicker = lightPicker;
			cubeMaterial.mipmap = false;

			var weaveDiffuseTexture:BitmapTexture = Cast.bitmapTexture(resourceDic[WeaveDiffuse]);
			torusMaterial = new TextureMaterial(weaveDiffuseTexture);
			torusMaterial.specularMap = weaveDiffuseTexture;
			torusMaterial.normalMap = Cast.bitmapTexture(resourceDic[WeaveNormals]);
			torusMaterial.lightPicker = lightPicker;
			torusMaterial.repeat = true;
		}

		/**
		 * Initialise the lights
		 */
		private function initLights():void
		{
			light1 = new DirectionalLight();
			light1.direction = new Vector3D(0, -1, 0);
			light1.ambient = 0.1;
			light1.diffuse = 0.7;

			scene.addChild(light1);

			light2 = new DirectionalLight();
			light2.direction = new Vector3D(0, -1, 0);
			light2.color = 0x00FFFF;
			light2.ambient = 0.1;
			light2.diffuse = 0.7;

			scene.addChild(light2);

			lightPicker = new StaticLightPicker([light1, light2]);
		}

		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{
			plane = new Mesh(new PlaneGeometry(1000, 1000), planeMaterial);
			plane.geometry.scaleUV(2, 2);
			plane.y = -20;

			scene.addChild(plane);

			sphere = new Mesh(new SphereGeometry(150, 40, 20), sphereMaterial);
			sphere.x = 300;
			sphere.y = 160;
			sphere.z = 300;

			scene.addChild(sphere);

			cube = new Mesh(new CubeGeometry(200, 200, 200, 1, 1, 1, false), cubeMaterial);
			cube.x = 300;
			cube.y = 160;
			cube.z = -250;

			scene.addChild(cube);

			torus = new Mesh(new TorusGeometry(150, 60, 40, 20), torusMaterial);
			torus.geometry.scaleUV(10, 5);
			torus.x = -250;
			torus.y = 160;
			torus.z = -250;

			scene.addChild(torus);
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

			light1.direction = new Vector3D(Math.sin(getTimer() / 10000) * 150000, 1000, Math.cos(getTimer() / 10000) * 150000);

			view.render();
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

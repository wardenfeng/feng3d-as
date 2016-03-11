package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import me.feng3d.cameras.Camera3D;
	import me.feng3d.containers.Container3D;
	import me.feng3d.containers.Scene3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.controllers.LookAtController;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.debug.Debug;
	import me.feng3d.entities.Mesh;
	import me.feng3d.lights.DirectionalLight;
	import me.feng3d.lights.shadowmaps.NearDirectionalShadowMapper;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.materials.lightpickers.StaticLightPicker;
	import me.feng3d.materials.methods.FilteredShadowMapMethod;
	import me.feng3d.materials.methods.NearShadowMapMethod;
	import me.feng3d.primitives.PlaneGeometry;
	import me.feng3d.primitives.SphereGeometry;
	import me.feng3d.test.TestBase;
	import me.feng3d.utils.Cast;

	/**
	 * 测试阴影
	 */
	[SWF(backgroundColor = "#000000", frameRate = "60")]
	public class ShadowTest extends TestBase
	{
		//floor diffuse map
		private var FloorDiffuse:String = "embeds/rockbase_diffuse.jpg";

		//floor normal map
		private var FloorNormals:String = "embeds/rockbase_normals.png";

		//floor specular map
		private var FloorSpecular:String = "embeds/rockbase_specular.png";

		//body diffuse map
		private var BodyDiffuse:String = "embeds/hellknight/hellknight_diffuse.jpg";

		//body normal map
		private var BodyNormals:String = "embeds/hellknight/hellknight_normals.png";

		//bidy specular map
		private var BodySpecular:String = "embeds/hellknight/hellknight_specular.png";

		//engine variables
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		private var cameraController:LookAtController;

		//light objects
		private var whiteLight:DirectionalLight;
		private var lightPicker:StaticLightPicker;
		private var shadowMapMethod:NearShadowMapMethod;
		private var count:Number = 0;

		//material objects
		private var groundMaterial:TextureMaterial;
		private var bodyMaterial:TextureMaterial;

		//scene objects
		private var placeHolder:Container3D;
		private var mesh:Mesh;
		private var ground:Mesh;

		/**
		 * Constructor
		 */
		public function ShadowTest()
		{
			resourceList = [FloorDiffuse, FloorNormals, FloorSpecular, BodyDiffuse, BodyNormals, BodySpecular];
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

			Debug.agalDebug = true;
			view = new View3D();
			scene = view.scene;
			camera = view.camera;

			camera.lens.far = 5000;
			camera.transform3D.z = -200;
			camera.transform3D.y = 160;

			//setup controller to be used on the camera
			placeHolder = new Container3D();
			placeHolder.transform3D.y = 50;
			cameraController = new LookAtController(camera, placeHolder);

			view.addSourceURL("srcview/index.html");
			addChild(view);
		}

		/**
		 * Initialise the lights
		 */
		private function initLights():void
		{
			whiteLight = new DirectionalLight(-50, -20, 10);
			whiteLight.color = 0xffffee;
			whiteLight.castsShadows = true;
			whiteLight.ambient = 1;
			whiteLight.ambientColor = 0x303040;
			whiteLight.shadowMapper = new NearDirectionalShadowMapper(.2);
			scene.addChild(whiteLight);

			lightPicker = new StaticLightPicker([whiteLight]);


			//create a global shadow method
			shadowMapMethod = new NearShadowMapMethod(new FilteredShadowMapMethod(whiteLight), 0.6);
			shadowMapMethod.epsilon = .1;
		}

		/**
		 * Initialise the materials
		 */
		private function initMaterials():void
		{
			//ground material
			groundMaterial = new TextureMaterial(Cast.bitmapTexture(resourceDic[FloorDiffuse]));
			groundMaterial.smooth = true;
			groundMaterial.repeat = true;
			groundMaterial.mipmap = true;
			groundMaterial.lightPicker = lightPicker;
			groundMaterial.normalMap = Cast.bitmapTexture(resourceDic[FloorNormals]);
			groundMaterial.specularMap = Cast.bitmapTexture(resourceDic[FloorSpecular]);
			groundMaterial.shadowMethod = shadowMapMethod;

			//body material
			bodyMaterial = new TextureMaterial(Cast.bitmapTexture(resourceDic[BodyDiffuse]));
			bodyMaterial.specular = 1.5;
			bodyMaterial.specularMap = Cast.bitmapTexture(resourceDic[BodySpecular]);
			bodyMaterial.normalMap = Cast.bitmapTexture(resourceDic[BodyNormals]);
			bodyMaterial.lightPicker = lightPicker;
			bodyMaterial.shadowMethod = shadowMapMethod;
		}

		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{
			initMesh();

			//create a snowy ground plane
			ground = new Mesh(new PlaneGeometry(50000, 50000, 1, 1), groundMaterial);
			ground.geometry.scaleUV(200, 200);
			ground.castsShadows = false;
			scene.addChild(ground);
		}

		/**
		 * Initialise the hellknight mesh
		 */
		private function initMesh():void
		{
			//grab mesh object and assign our material object

			var sphereGeometry:Geometry = new SphereGeometry();

			mesh = new Mesh(sphereGeometry, bodyMaterial);
			mesh.castsShadows = true;
			mesh.transform3D.y = 50;
			mesh.transform3D.z = 200;

			scene.addChild(mesh);

			//add our lookat object to the mesh
			mesh.addChild(placeHolder);
		}

		/**
		 * Initialise the listeners
		 */
		private function initListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}

		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void
		{
			cameraController.update();

			//update character animation
			if (mesh)
				mesh.transform3D.rotationY += 1;

			count += 0.01;

			view.render();
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

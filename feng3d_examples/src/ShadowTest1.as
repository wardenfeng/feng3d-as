package
{
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;

	import me.feng3d.animators.skeleton.SkeletonAnimationSet;
	import me.feng3d.animators.skeleton.SkeletonAnimator;
	import me.feng3d.animators.skeleton.SkeletonClipNode;
	import me.feng3d.animators.skeleton.data.Skeleton;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.containers.ObjectContainer3D;
	import me.feng3d.containers.Scene3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.controllers.LookAtController;
	import me.feng3d.debug.Debug;
	import me.feng3d.entities.Mesh;
	import me.feng3d.events.AnimatorEvent;
	import me.feng3d.events.AssetEvent;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.lights.DirectionalLight;
	import me.feng3d.lights.shadowmaps.NearDirectionalShadowMapper;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.materials.lightpickers.StaticLightPicker;
	import me.feng3d.materials.methods.FilteredShadowMapMethod;
	import me.feng3d.materials.methods.NearShadowMapMethod;
	import me.feng3d.parsers.MD5AnimParser;
	import me.feng3d.parsers.MD5MeshParser;
	import me.feng3d.primitives.PlaneGeometry;
	import me.feng3d.test.TestBase;
	import me.feng3d.textures.BitmapTexture;
	import me.feng3d.utils.Cast;

	/**
	 * 测试阴影
	 */
	[SWF(backgroundColor = "#000000", frameRate = "60")]
	public class ShadowTest1 extends TestBase
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
		private var placeHolder:ObjectContainer3D;
		private var mesh:Mesh;
		private var ground:Mesh;

		private var isRunning:Boolean;
		private var isMoving:Boolean;
		private var movementDirection:Number;
		private var onceAnim:String;
		private var currentAnim:String;

		private var skeleton:Skeleton;
		private var animator:SkeletonAnimator;
		private var animationSet:SkeletonAnimationSet;

		private const IDLE_NAME:String = "idle2";
		private const WALK_NAME:String = "walk7";

		private const RUN_SPEED:Number = 2;
		private const WALK_SPEED:Number = 1;
		private const IDLE_SPEED:Number = 1;

		// Assets.
		private var HellKnight_Mesh:String = "embeds/hellknight/hellknight.md5mesh";

		private var HellKnight_Idle2:String = "embeds/hellknight/idle2.md5anim";

		private const PAINT_TEXTURE_SIZE:uint = 1024;

		/**
		 * Constructor
		 */
		public function ShadowTest1()
		{
			resourceList = [FloorDiffuse, FloorNormals, FloorSpecular, BodyDiffuse, BodyNormals, BodySpecular, HellKnight_Mesh, HellKnight_Idle2];
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
			placeHolder = new ObjectContainer3D();
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
			//create a snowy ground plane
			ground = new Mesh(new PlaneGeometry(50000, 50000, 1, 1), groundMaterial);
			ground.geometry.scaleUV(200, 200);
			ground.castsShadows = false;
			scene.addChild(ground);

			// Load a head model that we will be able to paint on on mouse down.
			var parser:MD5MeshParser = new MD5MeshParser();
			parser.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			parser.parseAsync(resourceDic[HellKnight_Mesh]);
		}

		private function onAssetComplete(event:AssetEvent):void
		{
			if (event.asset.namedAsset.assetType == AssetType.ANIMATION_NODE)
			{

				var node:SkeletonClipNode = event.asset as SkeletonClipNode;
				var name:String = event.asset.name;
				node.name = name;
				animationSet.addAnimation(node);

				if (name == IDLE_NAME || name == WALK_NAME)
				{
					node.looping = true;
				}
				else
				{
					node.looping = false;
					node.addEventListener(AnimatorEvent.CYCLE_COMPLETE, onCycleComplete);
				}

				animator.play(name);

				if (name == IDLE_NAME)
					stop();
			}
			else if (event.asset.assetType == AssetType.ANIMATION_SET)
			{
				animationSet = event.asset as SkeletonAnimationSet;
				animator = new SkeletonAnimator(animationSet, skeleton, true);

				var parser:MD5AnimParser = new MD5AnimParser();
				parser.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
				parser.parseAsync(resourceDic[HellKnight_Idle2]);

				mesh.animator = animator;
			}
			else if (event.asset.assetType == AssetType.SKELETON)
			{
				skeleton = event.asset as Skeleton;
			}
			else if (event.asset.assetType == AssetType.MESH)
			{
				mesh = event.asset as Mesh;
				initializeHeadModel(mesh);
			}
		}

		private function stop():void
		{
			isMoving = false;

			if (currentAnim == IDLE_NAME)
				return;

			currentAnim = IDLE_NAME;

			if (onceAnim)
				return;

			//update animator
			animator.playbackSpeed = IDLE_SPEED;
			animator.play(currentAnim);
		}

		private function onCycleComplete(event:AnimatorEvent):void
		{
			onceAnim = null;

			animator.play(currentAnim);
			animator.playbackSpeed = isMoving ? movementDirection * (isRunning ? RUN_SPEED : WALK_SPEED) : IDLE_SPEED;
		}

		private function initializeHeadModel(model:Mesh):void
		{

			mesh = model;

			// Apply a bitmap material that can be painted on.
			var bmd:BitmapData = new BitmapData(PAINT_TEXTURE_SIZE, PAINT_TEXTURE_SIZE, false, 0xFF0000);
			bmd.perlinNoise(50, 50, 8, 1, false, true, 7, true);
			var bitmapTexture:BitmapTexture = new BitmapTexture(bmd);
			var textureMaterial:TextureMaterial = new TextureMaterial(bitmapTexture);
			model.material = textureMaterial;

//			model.showBounds = true;

			scene.addChild(model);
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

			count += 0.01;
			var _direction:Vector3D = new Vector3D(-1, -0.5, 1);
			_direction.x = -Math.sin(getTimer() / 4000);
			_direction.z = -Math.cos(getTimer() / 4000);
			whiteLight.direction = _direction;
			whiteLight.direction.x

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

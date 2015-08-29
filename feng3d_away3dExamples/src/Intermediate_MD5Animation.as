/*

MD5 animation loading and interaction example in Away3d

Demonstrates:

How to load MD5 mesh and anim files with bones animation from embedded resources.
How to map animation data after loading in order to playback an animation sequence.
How to control the movement of a game character using keys.

Code by Rob Bateman & David Lenaerts
rob@infiniteturtles.co.uk
http://www.infiniteturtles.co.uk
david.lenaerts@gmail.com
http://www.derschmale.com

This code is distributed under the MIT License

Copyright (c) The Away Foundation http://www.theawayfoundation.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	import away3d.debug.AwayStats;

	import br.com.stimuli.loading.BulkLoader;

	import me.feng3d.animators.skeleton.SkeletonAnimationSet;
	import me.feng3d.animators.skeleton.SkeletonAnimator;
	import me.feng3d.animators.skeleton.SkeletonClipNode;
	import me.feng3d.animators.skeleton.data.Skeleton;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.containers.ObjectContainer3D;
	import me.feng3d.containers.Scene3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.controllers.LookAtController;
	import me.feng3d.entities.Mesh;
	import me.feng3d.entities.SkyBox;
	import me.feng3d.entities.Sprite3D;
	import me.feng3d.events.AnimationStateEvent;
	import me.feng3d.events.AssetEvent;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.lights.DirectionalLight;
	import me.feng3d.lights.PointLight;
	import me.feng3d.lights.shadowmaps.NearDirectionalShadowMapper;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.materials.lightpickers.StaticLightPicker;
	import me.feng3d.materials.methods.FilteredShadowMapMethod;
	import me.feng3d.materials.methods.FogMethod;
	import me.feng3d.materials.methods.NearShadowMapMethod;
	import me.feng3d.parsers.MD5AnimParser;
	import me.feng3d.parsers.MD5MeshParser;
	import me.feng3d.primitives.PlaneGeometry;
	import me.feng3d.textures.BitmapCubeTexture;
	import me.feng3d.utils.Cast;

	[SWF(backgroundColor = "#000000", frameRate = "30")]
	public class Intermediate_MD5Animation extends TestBase
	{
		//signature swf
		public var SignatureSwf:String = "embeds/signature.swf"

		//floor diffuse map
		private var FloorDiffuse:String = "embeds/rockbase_diffuse.jpg"

		//floor normal map
		private var FloorNormals:String = "embeds/rockbase_normals.png"

		//floor specular map
		private var FloorSpecular:String = "embeds/rockbase_specular.png"

		//body diffuse map
		private var BodyDiffuse:String = "embeds/hellknight/hellknight_diffuse.jpg"

		//body normal map
		private var BodyNormals:String = "embeds/hellknight/hellknight_normals.png"

		//bidy specular map
		private var BodySpecular:String = "embeds/hellknight/hellknight_specular.png"

		//skybox
		private var EnvPosX:String = "embeds/skybox/grimnight_posX.png"
		private var EnvPosY:String = "embeds/skybox/grimnight_posY.png"
		private var EnvPosZ:String = "embeds/skybox/grimnight_posZ.png"
		private var EnvNegX:String = "embeds/skybox/grimnight_negX.png"
		private var EnvNegY:String = "embeds/skybox/grimnight_negY.png"
		private var EnvNegZ:String = "embeds/skybox/grimnight_negZ.png"

		//billboard texture for red light
		private var RedLight:String = "embeds/redlight.png"

		//billboard texture for blue light
		private var BlueLight:String = "embeds/bluelight.png"

		//hellknight mesh
		private var HellKnight_Mesh:String = "embeds/hellknight/hellknight.md5mesh"

		//hellknight animations
		private var HellKnight_Idle2:String = "embeds/hellknight/idle2.md5anim"
		private var HellKnight_Walk7:String = "embeds/hellknight/walk7.md5anim"
		private var HellKnight_Attack3:String = "embeds/hellknight/attack3.md5anim"
		private var HellKnight_TurretAttack:String = "embeds/hellknight/turret_attack.md5anim"
		private var HellKnight_Attack2:String = "embeds/hellknight/attack2.md5anim"
		private var HellKnight_Chest:String = "embeds/hellknight/chest.md5anim"
		private var HellKnight_Roar1:String = "embeds/hellknight/roar1.md5anim"
		private var HellKnight_LeftSlash:String = "embeds/hellknight/leftslash.md5anim"
		private var HellKnight_HeadPain:String = "embeds/hellknight/headpain.md5anim"
		private var HellKnight_Pain1:String = "embeds/hellknight/pain1.md5anim"
		private var HellKnight_PainLUPArm:String = "embeds/hellknight/pain_luparm.md5anim"
		private var HellKnight_RangeAttack2:String = "embeds/hellknight/range_attack2.md5anim"

		//engine variables
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		private var cameraController:LookAtController;
		private var awayStats:AwayStats;

		//animation variables
		private var animator:SkeletonAnimator;
		private var animationSet:SkeletonAnimationSet;
//		private var stateTransition:CrossfadeTransition = new CrossfadeTransition(0.5);
		private var skeleton:Skeleton;
		private var isRunning:Boolean;
		private var isMoving:Boolean;
		private var movementDirection:Number;
		private var onceAnim:String;
		private var currentAnim:String;
		private var currentRotationInc:Number = 0;

		//animation constants
		private const IDLE_NAME:String = "idle2";
		private const WALK_NAME:String = "walk7";
		private const ANIM_NAMES:Array = [IDLE_NAME, WALK_NAME, "attack3", "turret_attack", "attack2", "chest", "roar1", "leftslash", "headpain", "pain1", "pain_luparm", "range_attack2"];
		private const ANIM_CLASSES:Array = [HellKnight_Idle2, HellKnight_Walk7, HellKnight_Attack3, HellKnight_TurretAttack, HellKnight_Attack2, HellKnight_Chest, HellKnight_Roar1, HellKnight_LeftSlash, HellKnight_HeadPain, HellKnight_Pain1, HellKnight_PainLUPArm, HellKnight_RangeAttack2];
		private const ROTATION_SPEED:Number = 3;
		private const RUN_SPEED:Number = 2;
		private const WALK_SPEED:Number = 1;
		private const IDLE_SPEED:Number = 1;
		private const ACTION_SPEED:Number = 1;

		//signature variables
		private var Signature:Sprite;
		private var SignatureBitmap:Bitmap;

		//light objects
		private var redLight:PointLight;
		private var blueLight:PointLight;
		private var whiteLight:DirectionalLight;
		private var lightPicker:StaticLightPicker;
		private var shadowMapMethod:NearShadowMapMethod;
		private var fogMethod:FogMethod;
		private var count:Number = 0;

		//material objects
		private var redLightMaterial:TextureMaterial;
		private var blueLightMaterial:TextureMaterial;
		private var groundMaterial:TextureMaterial;
		private var bodyMaterial:TextureMaterial;
		private var cubeTexture:BitmapCubeTexture;

		//scene objects
		private var text:TextField;
		private var placeHolder:ObjectContainer3D;
		private var mesh:Mesh;
		private var ground:Mesh;
		private var skyBox:SkyBox;
		private var animationNameDic:Dictionary = new Dictionary();

		/**
		 * Constructor
		 */
		public function Intermediate_MD5Animation()
		{
			resourceList = [ //
				SignatureSwf, FloorDiffuse, FloorNormals, FloorSpecular, BodyDiffuse, BodyNormals, BodySpecular, //
				EnvPosX, EnvPosY, EnvPosZ, EnvNegX, EnvNegY, EnvNegZ, //
				RedLight, BlueLight, //
				{url: HellKnight_Mesh, type: BulkLoader.TYPE_BINARY}, //
				{url: HellKnight_Idle2, type: BulkLoader.TYPE_BINARY}, //
				{url: HellKnight_Walk7, type: BulkLoader.TYPE_BINARY}, //
				{url: HellKnight_Attack3, type: BulkLoader.TYPE_BINARY}, //
				{url: HellKnight_TurretAttack, type: BulkLoader.TYPE_BINARY}, //
				{url: HellKnight_Attack2, type: BulkLoader.TYPE_BINARY}, //
				{url: HellKnight_Chest, type: BulkLoader.TYPE_BINARY}, //
				{url: HellKnight_Roar1, type: BulkLoader.TYPE_BINARY}, //
				{url: HellKnight_LeftSlash, type: BulkLoader.TYPE_BINARY}, //
				{url: HellKnight_HeadPain, type: BulkLoader.TYPE_BINARY}, //
				{url: HellKnight_Pain1, type: BulkLoader.TYPE_BINARY}, //
				{url: HellKnight_PainLUPArm, type: BulkLoader.TYPE_BINARY}, //
				{url: HellKnight_RangeAttack2, type: BulkLoader.TYPE_BINARY} //
				];
			super();
		}

		public function init():void
		{
			initEngine();
			initText();
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

			view = new View3D();
			scene = view.scene;
			camera = view.camera;

			camera.lens.far = 5000;
			camera.z = -200;
			camera.y = 160;

			//setup controller to be used on the camera
			placeHolder = new ObjectContainer3D();
			placeHolder.y = 50;
			cameraController = new LookAtController(camera, placeHolder);

			view.addSourceURL("srcview/index.html");
			addChild(view);

			//add signature
			Signature = resourceDic[SignatureSwf];
			SignatureBitmap = new Bitmap(new BitmapData(Signature.width, Signature.height, true, 0));
			stage.quality = StageQuality.HIGH;
			SignatureBitmap.bitmapData.draw(Signature);
			stage.quality = StageQuality.LOW;
			addChild(SignatureBitmap);

			awayStats = new AwayStats(view);
			addChild(awayStats);
		}

		/**
		 * Create an instructions overlay
		 */
		private function initText():void
		{
			text = new TextField();
			text.defaultTextFormat = new TextFormat("Verdana", 11, 0xFFFFFF);
			text.width = 240;
			text.height = 100;
			text.selectable = false;
			text.mouseEnabled = false;
			text.text = "Cursor keys / WSAD - move\n";
			text.appendText("SHIFT - hold down to run\n");
			text.appendText("Numbers 1-9 - Attack\n");
			text.filters = [new DropShadowFilter(1, 45, 0x0, 1, 0, 0)];

			addChild(text);
		}

		/**
		 * Initialise the lights
		 */
		private function initLights():void
		{
			//create a light for shadows that mimics the sun's position in the skybox
			redLight = new PointLight();
			redLight.x = -1000;
			redLight.y = 200;
			redLight.z = -1400;
			redLight.color = 0xff1111;
			scene.addChild(redLight);

			blueLight = new PointLight();
			blueLight.x = 1000;
			blueLight.y = 200;
			blueLight.z = 1400;
			blueLight.color = 0x1111ff;
			scene.addChild(blueLight);

			whiteLight = new DirectionalLight(-50, -20, 10);
			whiteLight.color = 0xffffee;
			whiteLight.castsShadows = true;
			whiteLight.ambient = 1;
			whiteLight.ambientColor = 0x303040;
			whiteLight.shadowMapper = new NearDirectionalShadowMapper(.2);
			scene.addChild(whiteLight);

			lightPicker = new StaticLightPicker([redLight, blueLight, whiteLight]);


			//create a global shadow method
			shadowMapMethod = new NearShadowMapMethod(new FilteredShadowMapMethod(whiteLight));
			shadowMapMethod.epsilon = .1;

			//create a global fog method
			fogMethod = new FogMethod(0, camera.lens.far * 0.5, 0x000000);
		}

		/**
		 * Initialise the materials
		 */
		private function initMaterials():void
		{
			//red light material
			redLightMaterial = new TextureMaterial(Cast.bitmapTexture(resourceDic[RedLight]));
			redLightMaterial.alphaBlending = true;
			redLightMaterial.addMethod(fogMethod);

			//blue light material
			blueLightMaterial = new TextureMaterial(Cast.bitmapTexture(resourceDic[BlueLight]));
			blueLightMaterial.alphaBlending = true;
			blueLightMaterial.addMethod(fogMethod);

			//ground material
			groundMaterial = new TextureMaterial(Cast.bitmapTexture(resourceDic[FloorDiffuse]));
			groundMaterial.smooth = true;
			groundMaterial.repeat = true;
			groundMaterial.mipmap = true;
			groundMaterial.lightPicker = lightPicker;
			groundMaterial.normalMap = Cast.bitmapTexture(resourceDic[FloorNormals]);
			groundMaterial.specularMap = Cast.bitmapTexture(resourceDic[FloorSpecular]);
			groundMaterial.shadowMethod = shadowMapMethod;
			groundMaterial.addMethod(fogMethod);

			//body material
			bodyMaterial = new TextureMaterial(Cast.bitmapTexture(resourceDic[BodyDiffuse]));
			bodyMaterial.gloss = 20;
			bodyMaterial.specular = 1.5;
			bodyMaterial.specularMap = Cast.bitmapTexture(resourceDic[BodySpecular]);
			bodyMaterial.normalMap = Cast.bitmapTexture(resourceDic[BodyNormals]);
			bodyMaterial.addMethod(fogMethod);
			bodyMaterial.lightPicker = lightPicker;
			bodyMaterial.shadowMethod = shadowMapMethod;
		}

		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{
			//create light billboards
			redLight.addChild(new Sprite3D(redLightMaterial, 200, 200));
			blueLight.addChild(new Sprite3D(blueLightMaterial, 200, 200));

			//AssetLibrary.enableParser(MD5MeshParser);
			//AssetLibrary.enableParser(MD5AnimParser);

			initMesh();

			//create a snowy ground plane
			ground = new Mesh(new PlaneGeometry(50000, 50000, 1, 1), groundMaterial);
			ground.geometry.scaleUV(200, 200);
			ground.castsShadows = false;
			scene.addChild(ground);

			//create a skybox
			cubeTexture = new BitmapCubeTexture(Cast.bitmapData(resourceDic[EnvPosX]), Cast.bitmapData(resourceDic[EnvNegX]), Cast.bitmapData(resourceDic[EnvPosY]), Cast.bitmapData(resourceDic[EnvNegY]), Cast.bitmapData(resourceDic[EnvPosZ]), Cast.bitmapData(resourceDic[EnvNegZ]));
			skyBox = new SkyBox(cubeTexture);
			scene.addChild(skyBox);
		}

		/**
		 * Initialise the hellknight mesh
		 */
		private function initMesh():void
		{
			//parse hellknight mesh
			var parser:MD5MeshParser = new MD5MeshParser();
			parser.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			parser.parseAsync(resourceDic[HellKnight_Mesh]);
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
				mesh.rotationY += currentRotationInc;

			count += 0.01;

			redLight.x = Math.sin(count) * 1500;
			redLight.y = 250 + Math.sin(count * 0.54) * 200;
			redLight.z = Math.cos(count * 0.7) * 1500;
			blueLight.x = -Math.sin(count * 0.8) * 1500;
			blueLight.y = 250 - Math.sin(count * .65) * 200;
			blueLight.z = -Math.cos(count * 0.9) * 1500;

			view.render();
		}

		/**
		 * Listener function for asset complete event on loader
		 */
		private function onAssetComplete(event:AssetEvent):void
		{
			if (event.asset.assetType == AssetType.ANIMATION_NODE)
			{

				var node:SkeletonClipNode = event.asset as SkeletonClipNode;
				var animationName:String = animationNameDic[event.currentTarget];
				node.name = animationName;
				animationSet.addAnimation(node);

				if (animationName == IDLE_NAME || animationName == WALK_NAME)
				{
					node.looping = true;
				}
				else
				{
					node.looping = false;
					node.addEventListener(AnimationStateEvent.PLAYBACK_COMPLETE, onPlaybackComplete);
				}

				if (animationName == IDLE_NAME)
					stop();
			}
			else if (event.asset.assetType == AssetType.ANIMATION_SET)
			{
				animationSet = event.asset as SkeletonAnimationSet;
				animator = new SkeletonAnimator(animationSet, skeleton, true);
				for (var i:uint = 0; i < ANIM_NAMES.length; ++i)
				{
					var parser:MD5AnimParser = new MD5AnimParser();
					parser.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
					parser.parseAsync(resourceDic[ANIM_CLASSES[i]]);

					animationNameDic[parser] = ANIM_NAMES[i];
				}

				mesh.animator = animator;
			}
			else if (event.asset.assetType == AssetType.SKELETON)
			{
				skeleton = event.asset as Skeleton;
			}
			else if (event.asset.assetType == AssetType.MESH)
			{
				//grab mesh object and assign our material object
				mesh = event.asset as Mesh;
				mesh.material = bodyMaterial;
				mesh.castsShadows = true;
				scene.addChild(mesh);

				//add our lookat object to the mesh
				mesh.addChild(placeHolder);

				//add key listeners
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
		}

		private function onPlaybackComplete(event:AnimationStateEvent):void
		{
			if (animator.activeState != event.animationState)
				return;

			onceAnim = null;

			animator.play(currentAnim);
			animator.playbackSpeed = isMoving ? movementDirection * (isRunning ? RUN_SPEED : WALK_SPEED) : IDLE_SPEED;
		}

		private function playAction(val:uint):void
		{
			onceAnim = ANIM_NAMES[val + 2];
			animator.playbackSpeed = ACTION_SPEED;
			animator.play(onceAnim, null, 0);
		}

		/**
		 * Key down listener for animation
		 */
		private function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.SHIFT:
					isRunning = true;
					if (isMoving)
						updateMovement(movementDirection);
					break;
				case Keyboard.UP:
				case Keyboard.W:
					updateMovement(movementDirection = 1);
					break;
				case Keyboard.DOWN:
				case Keyboard.S:
					updateMovement(movementDirection = -1);
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
					currentRotationInc = -ROTATION_SPEED;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					currentRotationInc = ROTATION_SPEED;
					break;
				case Keyboard.NUMBER_1:
					playAction(1);
					break;
				case Keyboard.NUMBER_2:
					playAction(2);
					break;
				case Keyboard.NUMBER_3:
					playAction(3);
					break;
				case Keyboard.NUMBER_4:
					playAction(4);
					break;
				case Keyboard.NUMBER_5:
					playAction(5);
					break;
				case Keyboard.NUMBER_6:
					playAction(6);
					break;
				case Keyboard.NUMBER_7:
					playAction(7);
					break;
				case Keyboard.NUMBER_8:
					playAction(8);
					break;
				case Keyboard.NUMBER_9:
					playAction(9);
					break;
			}
		}

		private function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.SHIFT:
					isRunning = false;
					if (isMoving)
						updateMovement(movementDirection);
					break;
				case Keyboard.UP:
				case Keyboard.W:
				case Keyboard.DOWN:
				case Keyboard.S:
					stop();
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
				case Keyboard.RIGHT:
				case Keyboard.D:
					currentRotationInc = 0;
					break;
			}
		}

		private function updateMovement(dir:Number):void
		{
			isMoving = true;
			animator.playbackSpeed = dir * (isRunning ? RUN_SPEED : WALK_SPEED);

			if (currentAnim == WALK_NAME)
				return;

			currentAnim = WALK_NAME;

			if (onceAnim)
				return;

			//update animator
			animator.play(currentAnim);
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

		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
			SignatureBitmap.y = stage.stageHeight - Signature.height;
			awayStats.x = stage.stageWidth - awayStats.width;
		}
	}
}

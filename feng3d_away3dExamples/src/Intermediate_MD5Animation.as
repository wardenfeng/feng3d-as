package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	import me.feng3d.animators.skeleton.SkeletonAnimationSet;
	import me.feng3d.animators.skeleton.SkeletonAnimator;
	import me.feng3d.animators.skeleton.SkeletonClipNode;
	import me.feng3d.animators.skeleton.data.Skeleton;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.containers.ObjectContainer3D;
	import me.feng3d.containers.Scene3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.entities.Mesh;
	import me.feng3d.events.AnimatorEvent;
	import me.feng3d.events.AssetEvent;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.parsers.MD5AnimParser;
	import me.feng3d.parsers.MD5MeshParser;
	import me.feng3d.utils.Cast;

	[SWF(width = "640", height = "360", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class Intermediate_MD5Animation extends TestBase
	{
		//body diffuse map
		private var BodyDiffusePath:String = "embeds/hellknight/hellknight_diffuse.jpg";

		//body normal map
		private var BodyNormalsPath:String = "embeds/hellknight/hellknight_normals.png";

		//bidy specular map
		private var BodySpecularPath:String = "embeds/hellknight/hellknight_specular.png";

		//hellknight mesh
		private var HellKnight_MeshPath:String = "embeds/hellknight/hellknight.md5mesh";

		//hellknight animations
		private var HellKnight_Idle2Path:String = "embeds/hellknight/idle2.md5anim";
		private var HellKnight_Walk7Path:String = "embeds/hellknight/walk7.md5anim";
		private var HellKnight_Attack3Path:String = "embeds/hellknight/attack3.md5anim";
		private var HellKnight_TurretAttackPath:String = "embeds/hellknight/turret_attack.md5anim";
		private var HellKnight_Attack2Path:String = "embeds/hellknight/attack2.md5anim";
		private var HellKnight_ChestPath:String = "embeds/hellknight/chest.md5anim";
		private var HellKnight_Roar1Path:String = "embeds/hellknight/roar1.md5anim";
		private var HellKnight_LeftSlashPath:String = "embeds/hellknight/leftslash.md5anim";
		private var HellKnight_HeadPainPath:String = "embeds/hellknight/headpain.md5anim";
		private var HellKnight_Pain1Path:String = "embeds/hellknight/pain1.md5anim";
		private var HellKnight_PainLUPArmPath:String = "embeds/hellknight/pain_luparm.md5anim";
		private var HellKnight_RangeAttack2Path:String = "embeds/hellknight/range_attack2.md5anim";

		//engine variables
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;

		//animation variables
		private var animator:SkeletonAnimator;
		private var animationSet:SkeletonAnimationSet;
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
		private const ANIM_CLASSES:Array = [HellKnight_Idle2Path, HellKnight_Walk7Path, HellKnight_Attack3Path, HellKnight_TurretAttackPath, HellKnight_Attack2Path, HellKnight_ChestPath, HellKnight_Roar1Path, HellKnight_LeftSlashPath, HellKnight_HeadPainPath, HellKnight_Pain1Path, HellKnight_PainLUPArmPath, HellKnight_RangeAttack2Path];
		private const ROTATION_SPEED:Number = 3;
		private const RUN_SPEED:Number = 2;
		private const WALK_SPEED:Number = 1;
		private const IDLE_SPEED:Number = 1;
		private const ACTION_SPEED:Number = 1;

		//light objects
		private var count:Number = 0;

		//material objects
		private var redLightMaterial:TextureMaterial;
		private var blueLightMaterial:TextureMaterial;
		private var groundMaterial:TextureMaterial;
		private var bodyMaterial:TextureMaterial;

		//scene objects
		private var text:TextField;
		private var placeHolder:ObjectContainer3D;
		private var mesh:Mesh;
		private var ground:Mesh;

		private var animationNameDic:Dictionary = new Dictionary();

		/**
		 * Constructor
		 */
		public function Intermediate_MD5Animation()
		{
			resourceList = [BodyDiffusePath, BodyNormalsPath, BodySpecularPath, HellKnight_MeshPath, HellKnight_Idle2Path, HellKnight_Walk7Path, HellKnight_Attack3Path, HellKnight_TurretAttackPath, HellKnight_Attack2Path, HellKnight_ChestPath, HellKnight_Roar1Path, HellKnight_LeftSlashPath, HellKnight_HeadPainPath, HellKnight_Pain1Path, HellKnight_PainLUPArmPath, HellKnight_RangeAttack2Path,];

			super();
		}

		/**
		 * Global initialise function
		 */
		public function init():void
		{
			initEngine();
			initText();
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
			camera.z = -200;
			camera.y = 160;
			camera.lookAt(new Vector3D());

			addChild(view);

			//setup controller to be used on the camera
			placeHolder = new ObjectContainer3D();
			placeHolder.y = 50;
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
		 * Initialise the materials
		 */
		private function initMaterials():void
		{
			//body material
			bodyMaterial = new TextureMaterial(Cast.bitmapTexture(resourceDic[BodyDiffusePath]));
		}

		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{
			//AssetLibrary.enableParser(MD5MeshParser);
			//AssetLibrary.enableParser(MD5AnimParser);

			initMesh();
		}

		/**
		 * Initialise the hellknight mesh
		 */
		private function initMesh():void
		{
			//parse hellknight mesh
			var parser:MD5MeshParser = new MD5MeshParser();
			parser.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			parser.parseAsync(resourceDic[HellKnight_MeshPath]);
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
			//update character animation
			if (mesh)
				mesh.rotationY += currentRotationInc;

			count += 0.01;
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
				node.animationName = animationName;
				animationSet.addAnimation(node);

				if (animationName == IDLE_NAME || animationName == WALK_NAME)
				{
					node.looping = true;
				}
				else
				{
					node.looping = false;
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
//					AssetLibrary.loadData(new ANIM_CLASSES[i](), null, ANIM_NAMES[i], new MD5AnimParser());
				animator.addEventListener(AnimatorEvent.CYCLE_COMPLETE, onClycleComplete);

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
				scene.addChild(mesh);

				//add our lookat object to the mesh
				mesh.addChild(placeHolder);

				//add key listeners
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
		}

		private function onClycleComplete(event:AnimatorEvent):void
		{
			onceAnim = null;

			animator.play(currentAnim);
			animator.playbackSpeed = isMoving ? movementDirection * (isRunning ? RUN_SPEED : WALK_SPEED) : IDLE_SPEED;
		}

		private function playAction(val:uint):void
		{
			onceAnim = ANIM_NAMES[val + 2];
			animator.playbackSpeed = ACTION_SPEED;
			animator.play(onceAnim, 0);
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
		}
	}
}

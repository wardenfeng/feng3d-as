package
{
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Vector3D;

	import me.feng3d.animators.skeleton.SkeletonAnimationSet;
	import me.feng3d.animators.skeleton.SkeletonAnimator;
	import me.feng3d.animators.skeleton.SkeletonClipNode;
	import me.feng3d.animators.skeleton.data.Skeleton;
	import me.feng3d.containers.View3D;
	import me.feng3d.entities.Mesh;
	import me.feng3d.events.AssetEvent;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.parsers.MD5AnimParser;
	import me.feng3d.parsers.MD5MeshParser;
	import me.feng3d.textures.BitmapTexture;

	/**
	 * 测试MD5动画解析
	 * @author warden_feng 2014-4-29
	 */
	[SWF(width = "640", height = "360", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class SkeletonAnimatorTest extends TestBase
	{
		public var _view:View3D;

		private var mesh:Mesh;

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

		private const ROTATION_SPEED:Number = 3;
		private const RUN_SPEED:Number = 2;
		private const WALK_SPEED:Number = 1;
		private const IDLE_SPEED:Number = 1;
		private const ACTION_SPEED:Number = 1;

//		[Embed(source = "../embeds/onkba/onkba.MD5MESH", mimeType = "application/octet-stream")]
//		[Embed(source = "../embeds/hellknight/hellknight.md5mesh", mimeType = "application/octet-stream")]
		private var HellKnight_Mesh:String = "embeds/pan.md5mesh";

//		[Embed(source = "../embeds/onkba/pause.MD5ANIM", mimeType = "application/octet-stream")]
//		[Embed(source="../embeds/hellknight/idle2.md5anim", mimeType="application/octet-stream")]
		private var HellKnight_Idle2:String = "embeds/pan.md5anim";

		private const PAINT_TEXTURE_SIZE:uint = 1024;

		public function SkeletonAnimatorTest()
		{
			resourceList = [HellKnight_Mesh, HellKnight_Idle2];
			super();
		}

		public function init():void
		{
			stage.frameRate = 60;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			MyCC.initFlashConsole(this);

			_view = new View3D();
			addChild(_view);

			//setup the camera
			_view.camera.z = 100;
			_view.camera.y = 0;
			_view.camera.x = 100;
			_view.camera.lookAt(new Vector3D());

			initObjects();
		}

		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{
			// Load a head model that we will be able to paint on on mouse down.
			var parser:MD5MeshParser = new MD5MeshParser();
			parser.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			parser.parseAsync(resourceDic[HellKnight_Mesh]);
		}

		private function onAssetComplete(event:AssetEvent):void
		{
			if (event.asset.assetType == AssetType.ANIMATION_NODE)
			{

				var node:SkeletonClipNode = event.asset as SkeletonClipNode;
				var name:String = event.asset.name;
				node.animationName = name;
				animationSet.addAnimation(node);

				node.looping = true;

				animator.play(name);

				if (name == IDLE_NAME)
					stop();
			}
			else if (event.asset.assetType == AssetType.ANIMATION_SET)
			{
				animationSet = event.asset as SkeletonAnimationSet;
				animator = new SkeletonAnimator(animationSet, skeleton);

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
				mesh.scale(2);
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

		private function initializeHeadModel(model:Mesh):void
		{
			mesh = model;

			// Apply a bitmap material that can be painted on.
			var bmd:BitmapData = new BitmapData(PAINT_TEXTURE_SIZE, PAINT_TEXTURE_SIZE, false, 0xFF0000);
			bmd.perlinNoise(50, 50, 8, 1, false, true, 7, true);
			var bitmapTexture:BitmapTexture = new BitmapTexture(bmd);
			var textureMaterial:TextureMaterial = new TextureMaterial(bitmapTexture);
			model.material = textureMaterial;

			_view.scene.addChild(model);
		}
	}
}

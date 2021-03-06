package
{
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	import me.feng3d.animators.skeleton.SkeletonAnimationSet;
	import me.feng3d.animators.skeleton.SkeletonAnimator;
	import me.feng3d.animators.skeleton.SkeletonClipNode;
	import me.feng3d.animators.skeleton.data.Skeleton;
	import me.feng3d.containers.View3D;
	import me.feng3d.debug.Trident;
	import me.feng3d.entities.Mesh;
	import me.feng3d.events.AssetEvent;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.parsers.MD5AnimParser;
	import me.feng3d.parsers.MD5MeshParser;
	import me.feng3d.test.TestBase;
	import me.feng3d.textures.BitmapTexture;

	/**
	 * 测试MD5动画解析
	 * @author feng 2014-4-29
	 */
	[SWF(width = "640", height = "360", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class MD5AnimMeshParserTest extends TestBase
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

		private const IDLE_SPEED:Number = 1;

		// Assets.
		private var HellKnight_Mesh:String = "embeds/hellknight/hellknight.md5mesh";

		private var HellKnight_Idle2:String = "embeds/hellknight/idle2.md5anim";

		private const PAINT_TEXTURE_SIZE:uint = 1024;

		public function MD5AnimMeshParserTest()
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
			_view.camera.transform3D.z = 200;
			_view.camera.transform3D.y = 200;
			_view.camera.transform3D.x = 200;
			_view.camera.transform3D.lookAt(new Vector3D());

			//添加坐标系
			_view.scene.addChild(new Trident());

			initObjects();

			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
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
			var assetType:String = event.asset.namedAsset.assetType;
			if (assetType == AssetType.ANIMATION_NODE)
			{
				var node:SkeletonClipNode = event.asset as SkeletonClipNode;
				node.name = IDLE_NAME;
				animationSet.addAnimation(node);

				node.looping = true;

				animator.play(node.name);
			}
			else if (assetType == AssetType.ANIMATION_SET)
			{
				animationSet = event.asset as SkeletonAnimationSet;
				animator = new SkeletonAnimator(animationSet, skeleton, true);

				mesh.animator = animator;

				var parser:MD5AnimParser = new MD5AnimParser();
				parser.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
				parser.parseAsync(resourceDic[HellKnight_Idle2]);
			}
			else if (assetType == AssetType.SKELETON)
			{
				skeleton = event.asset as Skeleton;
			}
			else if (assetType == AssetType.MESH)
			{
				mesh = event.asset as Mesh;
				initializeHeadModel(mesh);
			}
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

			model.showBounds = true;

			_view.scene.addChild(model);
		}

		/**
		 * render loop
		 */
		private function _onEnterFrame(e:Event):void
		{
			if (mesh)
				mesh.transform3D.rotationY++;

			_view.render();
		}
	}
}

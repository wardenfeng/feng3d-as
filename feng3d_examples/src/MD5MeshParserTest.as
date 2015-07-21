package 
{
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	import me.feng3d.containers.View3D;
	import me.feng3d.debug.Trident;
	import me.feng3d.entities.Mesh;
	import me.feng3d.events.AssetEvent;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.parsers.MD5MeshParser;
	import me.feng3d.textures.BitmapTexture;

	/**
	 * 测试md5解析
	 * @author warden_feng 2014-4-29
	 */
	[SWF(width = "640", height = "480", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class MD5MeshParserTest extends TestBase
	{
		public var _view:View3D;

		private var head:Mesh;

		private var HellKnight_Mesh:String = "embeds/onkba/onkba.MD5MESH";

		private const PAINT_TEXTURE_SIZE:uint = 1024;

		public function MD5MeshParserTest()
		{
			resourceList = [HellKnight_Mesh];
			super();
		}

		public function init():void
		{
			stage.frameRate = 60;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			_view = new View3D();
			addChild(_view);

			//setup the camera
			_view.camera.z = 150;
			_view.camera.y = 150;
			_view.camera.x = 150;
			_view.camera.lookAt(new Vector3D());

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
			if (event.asset.assetType == AssetType.MESH)
			{
				initializeHeadModel(event.asset as Mesh);
			}
		}

		private function initializeHeadModel(model:Mesh):void
		{

			head = model;

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
			if (head)
				head.rotationY++;

			_view.render();
		}
	}
}

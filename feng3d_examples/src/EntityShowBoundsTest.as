package
{
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import me.feng3d.containers.View3D;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.debug.Trident;
	import me.feng3d.entities.Mesh;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDCommon;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.textures.BitmapTexture;
	
	import parser.ObjParser1;

	/**
	 * 显示物体边框
	 * @author warden_feng 2014-4-29
	 */
	[SWF(width = "640", height = "480", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class EntityShowBoundsTest extends TestBase
	{
		public var _view:View3D;

		private var head:Mesh;

		// Assets.
		private var HeadAsset:String = "art/head.obj";

		private const PAINT_TEXTURE_SIZE:uint = 1024;

		public function EntityShowBoundsTest()
		{
			resourceList = [HeadAsset];
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
			_view.camera.z = 200;
			_view.camera.y = 200;
			_view.camera.x = 200;
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
			var objParser:ObjParser1 = new ObjParser1(resourceDic[HeadAsset], 25);
			var terrainGeometry:Geometry = new Geometry();

			var sub:SubGeometry = new SubGeometry();
			terrainGeometry.addSubGeometry(sub);
			sub.updateIndexData(objParser.rawIndexBuffer);
			sub.numVertices = objParser.rawPositionsBuffer.length / 3;
			sub.updateVertexPositionData(objParser.rawPositionsBuffer);
			sub.setVAData(Context3DBufferTypeIDCommon.UV_VA_2, objParser.rawUvBuffer);

			head = new Mesh();
			head.name = "head";
			head.geometry = terrainGeometry;

			// Apply a bitmap material that can be painted on.
			var bmd:BitmapData = new BitmapData(PAINT_TEXTURE_SIZE, PAINT_TEXTURE_SIZE, false, 0xFF0000);
			bmd.perlinNoise(50, 50, 8, 1, false, true, 7, true);
			var bitmapTexture:BitmapTexture = new BitmapTexture(bmd);
			var textureMaterial:TextureMaterial = new TextureMaterial(bitmapTexture);
			head.material = textureMaterial;

			_view.scene.addChild(head);

			head.showBounds = true;
		}

		/**
		 * render loop
		 */
		private function _onEnterFrame(e:Event):void
		{
			if (head)
				head.rotationY++;


		}
	}
}

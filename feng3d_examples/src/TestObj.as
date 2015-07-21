package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	import me.feng3d.containers.View3D;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.debug.Trident;
	import me.feng3d.entities.Mesh;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.utils.Cast;

	import parser.ObjParser1;

	/**
	 *
	 * @author warden_feng 2014-3-14
	 */
	[SWF(width = "640", height = "480", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class TestObj extends TestBase
	{
		public var obj3d:Mesh;

		public var _view:View3D;

		// The terrain mesh data
		private var archMageObjData:String = "art/Arthas.obj";

		private var myTextureBitmap:String = "art/Arthas.JPG";

		public function TestObj()
		{
			resourceList = [archMageObjData, myTextureBitmap];
			super();
		}

		public function init(e:Event = null):void
		{
			stage.frameRate = 60;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			_view = new View3D();
			addChild(_view);

			_view.camera.z = -400;
			_view.camera.y = 100;
			_view.camera.x = 0;
			_view.camera.lookAt(new Vector3D());

			var objParser:ObjParser1 = new ObjParser1(resourceDic[archMageObjData], 1, true, true);
			var terrainGeometry:Geometry = objParser.getGeometry();

			obj3d = new Mesh();
			obj3d.name = "obj3d";
			obj3d.material = new TextureMaterial(Cast.bitmapTexture(resourceDic[myTextureBitmap]));
			obj3d.geometry = terrainGeometry;
			obj3d.rotationX = -90;
			_view.scene.addChild(obj3d);

			obj3d.addChild(new Trident());

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		protected function onEnterFrame(event:Event):void
		{
			obj3d.rotationY++;
		}


	} // end of class
} // end of package

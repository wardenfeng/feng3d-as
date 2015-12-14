package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import me.feng3d.containers.View3D;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.debug.Trident;
	import me.feng3d.entities.Mesh;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.test.TestBase;
	import me.feng3d.utils.Cast;

	import parser.ObjParser1;

	/**
	 *
	 * @author feng 2014-3-14
	 */
	[SWF(width = "640", height = "360", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class feng3d extends TestBase
	{
		private var terrain:Mesh;

		private var obj3d:Mesh;

		private var _view:View3D;

		// The terrain mesh data
		private var terrainObjData:String = "art/terrain.obj";

		private var terrainTextureBitmap:String = "art/terrain_texture.jpg";

		private var myObjData:String = "art/spaceship.obj";

		private var myTextureBitmap:String = "art/Arthas.JPG";

		private var t:Number = 0;

		public function feng3d()
		{
			resourceList = [terrainObjData, terrainTextureBitmap, myObjData, myTextureBitmap];
			super();
		}

		public function init():void
		{
			stage.frameRate = 60;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			_view = new View3D();
			addChild(_view);

			_view.camera.y = 300;
			_view.camera.x = 200;
			_view.camera.z = -200;
			_view.camera.lookAt(new Vector3D());

			var objParser:ObjParser1 = new ObjParser1(resourceDic[terrainObjData], 1, true, true);
			var terrainGeometry:Geometry = objParser.getGeometry();

			terrain = new Mesh();
			terrain.name = "terrain";
			terrain.material = new TextureMaterial(Cast.bitmapTexture(resourceDic[terrainTextureBitmap]), true, true);
			terrain.geometry = terrainGeometry;

			terrain.addChild(new Trident());

			_view.scene.addChild(terrain);

			_view.scene.addChild(new Trident());

			objParser = new ObjParser1(resourceDic[myObjData], 1, true, true);
			var terrainGeometry1:Geometry = objParser.getGeometry();

			obj3d = new Mesh();
			obj3d.name = "obj3d";
			obj3d..material = new TextureMaterial(Cast.bitmapTexture(resourceDic[myTextureBitmap]));
			obj3d.geometry = terrainGeometry1;
			obj3d.scaleX = obj3d.scaleY = obj3d.scaleZ = 100;

			_view.scene.addChild(obj3d);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		protected function onEnterFrame(event:Event):void
		{
			// move or rotate more each frame
			t += 2.0;

			terrain.x = Math.cos(t / 300) * 1000;
			terrain.y = -200;
			terrain.z = Math.cos(t / 200) * 1000;

			var viewmatrix:Matrix3D = new Matrix3D();
			// create a matrix that defines the camera location
			viewmatrix.identity();
			// move the camera back a little so we can see the mesh
			viewmatrix.appendTranslation(0, 0, 3);

			obj3d.rotationX = t * 0.6;
			obj3d.rotationY = t * 0.7;
			obj3d.rotationZ = t * 1.0;

			_view.render();
		}


	} // end of class
} // end of package

package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import feng3d.containers.View3D;
	import feng3d.core.base.Geometry;
	import feng3d.entities.Mesh;
	import feng3d.parsers.ObjParser;
	import feng3d.utils.Cast;

	/**
	 *
	 * @author warden_feng 2014-3-14
	 */
	[SWF(width = "640", height = "480", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class feng3d extends Sprite
	{
		private var terrain:Mesh;

		private var obj3d:Mesh;

		private var terrain1:Mesh;

		private var _view:View3D;

		// The terrain mesh data
		[Embed(source = "../art/terrain.obj", mimeType = "application/octet-stream")]
		private var terrainObjData:Class;

		[Embed(source = "../art/terrain_texture.jpg")]
		private var terrainTextureBitmap:Class;

		[Embed(source = "../art/spaceship.obj", mimeType = "application/octet-stream")]
		private var myObjData:Class;

		[Embed(source = "../art/HeroArchmage.JPG")]
		private var myTextureBitmap:Class;

		// a simple frame counter used for animation
		private var t:Number = 0;

		public var _transform:Matrix3D = new Matrix3D();

		public var modelmatrix:Matrix3D = new Matrix3D();

		public function feng3d()
		{
			if (stage != null)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{
			if (hasEventListener(Event.ADDED_TO_STAGE))
				removeEventListener(Event.ADDED_TO_STAGE, init);

			stage.frameRate = 60;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			_view = new View3D();
			addChild(_view);

			var objParser:ObjParser = new ObjParser(terrainObjData, 1, true, true);
			var terrainGeometry:Geometry = new Geometry();
			terrainGeometry.updateData(objParser);

			terrain = new Mesh();
			terrain.name = "terrain";
			terrain.bitmapTexture = Cast.bitmapTexture(terrainTextureBitmap);
			terrain.geometry = terrainGeometry;

			_transform.identity();
			_transform.appendRotation(-60, Vector3D.X_AXIS);
			_view.scene.addChild(terrain);

			objParser = new ObjParser(myObjData, 1, true, true);
			var terrainGeometry1:Geometry = new Geometry();
			terrainGeometry1.updateData(objParser);

			obj3d = new Mesh();
			obj3d.name = "obj3d";
			obj3d.bitmapTexture = Cast.bitmapTexture(myTextureBitmap);
			obj3d.geometry = terrainGeometry1;
			_view.scene.addChild(obj3d);

			terrain1 = new Mesh();
			terrain1.name = "obj3d1";
			terrain1.bitmapTexture = Cast.bitmapTexture(myTextureBitmap);
			terrain1.geometry = terrainGeometry;
			terrain1.transform.appendScale(0.5, 0.5, 0.5);
			terrain1.transform.appendTranslation(0, 0, -490);
			terrain.addChild(terrain1);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		protected function onEnterFrame(event:Event):void
		{
			// move or rotate more each frame
			t += 2.0;

			// set up camera angle
			modelmatrix.identity();
			// make the terrain face the right way
			modelmatrix.appendRotation(-90, Vector3D.Y_AXIS);
			// slowly move the terrain around
			modelmatrix.appendTranslation(Math.cos(t / 300) * 1000, Math.cos(t / 200) * 1000 + 500, -500);

			terrain.transform.identity();
			terrain.transform.append(modelmatrix);
			terrain.transform.append(_transform);

			var dist:Number = 0.8;
			modelmatrix.identity();
			modelmatrix.appendScale(1, 1, 1);
			modelmatrix.appendRotation(t * 0.7, Vector3D.Y_AXIS);
			modelmatrix.appendRotation(t * 0.6, Vector3D.X_AXIS);
			modelmatrix.appendRotation(t * 1.0, Vector3D.Y_AXIS);
			modelmatrix.appendTranslation(-dist, dist, 0);

			var viewmatrix:Matrix3D = new Matrix3D();
			// create a matrix that defines the camera location
			viewmatrix.identity();
			// move the camera back a little so we can see the mesh
			viewmatrix.appendTranslation(0, 0, -3);

			obj3d.transform.identity();
			obj3d.transform.append(modelmatrix);
			obj3d.transform.append(viewmatrix);
		}


	} // end of class
} // end of package

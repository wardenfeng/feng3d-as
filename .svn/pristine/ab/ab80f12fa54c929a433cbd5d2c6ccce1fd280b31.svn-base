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
	import feng3d.utils.Cast;

	/**
	 *
	 * @author warden_feng 2014-3-24
	 */
	[SWF(width = "640", height = "480", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class Test1 extends Sprite
	{
		private var _view:View3D;

		public var mesh:Mesh;

		[Embed(source = "../art/terrain_texture.jpg")]
		public static var FloorDiffuse:Class;

		public function Test1()
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

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			_view = new View3D();
			_view.camera.projectionmatrix.perspectiveFieldOfViewRH(45.0 * Math.PI / 180, stage.stageWidth / stage.stageHeight, 0.01, 100.0);
			addChild(_view);

			var geometry:Geometry = new Geometry();

			geometry.rawIndexBuffer = Vector.<uint>([ //
				0, 1, 2, //
				0, 2, 3, //
				]);
			geometry.rawPositionsBuffer = Vector.<Number>([
				//X,  Y,  Z		
				-1, -1, 1, //
				1, -1, 1, //
				1, 1, 1, //
				-1, 1, 1 //
				]);
			geometry.rawUvBuffer = Vector.<Number>([
				//U, V	
				0, 0, //
				1, 0, //
				1, 1, //
				0, 1 //
				]);

			mesh = new Mesh();
			mesh.bitmapTexture = Cast.bitmapTexture(FloorDiffuse);
			mesh.geometry = geometry;

			_view.scene.addChild(mesh);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private var t:Number = 0;

		protected function onEnterFrame(event:Event):void
		{
			var modelMatrix:Matrix3D = mesh.transform;
			modelMatrix.identity();
			modelMatrix.appendRotation(t * 0.7, Vector3D.Y_AXIS);
			modelMatrix.appendRotation(t * 0.6, Vector3D.X_AXIS);
			modelMatrix.appendRotation(t * 1.0, Vector3D.Y_AXIS);
			modelMatrix.appendTranslation(0.0, 0.0, 0.0);
			modelMatrix.appendRotation(90.0, Vector3D.X_AXIS);
			modelMatrix.appendTranslation(0, 0, -4);

			// rotate more next frame
			t += 2.0;
		}

	}
}

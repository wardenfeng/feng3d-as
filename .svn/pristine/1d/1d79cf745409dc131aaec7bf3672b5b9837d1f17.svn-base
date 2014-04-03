package pan
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import feng3d.Feng3dData;
	import feng3d.containers.View3D;
	import feng3d.core.base.Geometry;
	import feng3d.entities.Mesh;
	import feng3d.utils.Cast;

	/**
	 * (6)用四边形组成一个正方体并转动
	 * @author warden_feng 2014-3-27
	 */
	[SWF(width = "640", height = "640", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class Test2_6 extends Sprite
	{
		private var _view:View3D;

		public var mesh:Mesh;

		public function Test2_6()
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
			
			Feng3dData.viewWidth = 640;
			Feng3dData.viewHeight = 640;

			_view = new View3D();
			_view.camera.projectionmatrix.perspectiveFieldOfViewLH(angle * Math.PI / 180, stage.stageWidth / stage.stageHeight, 0.01, 10000.0);
			addChild(_view);

			var geometry:Geometry = new Geometry();

			geometry.rawIndexBuffer = Vector.<uint>([ //
				0, 1, 2, //
				0, 2, 3, //

				4, 5, 6, //
				4, 6, 7, //

				8, 9, 10, //
				8, 10, 11, //

				12, 13, 14, //
				12, 14, 15, //
				]);
			geometry.rawPositionsBuffer = Vector.<Number>([
				//X,  Y,  Z		
				-1, 1, -1, //
				1, 1, -1, //
				1, -1, -1, //
				-1, -1, -1, //

				1, 1, -1, //
				1, 1, 1, //
				1, -1, 1, //
				1, -1, -1, //

				1, 1, 1, //
				-1, 1, 1, //
				-1, -1, 1, //
				1, -1, 1, //

				-1, 1, 1, //
				-1, 1, -1, //
				-1, -1, -1, //
				-1, -1, 1, //

				]);
			geometry.rawUvBuffer = Vector.<Number>([
				//U, V	
				0, 0, //
				1, 0, //
				1, 1, //
				0, 1, //

				0, 0, //
				1, 0, //
				1, 1, //
				0, 1, //

				0, 0, //
				1, 0, //
				1, 1, //
				0, 1, //

				0, 0, //
				1, 0, //
				1, 1, //
				0, 1, //
				]);

			mesh = new Mesh();
			mesh.bitmapTexture = Cast.bitmapTexture(Asset.PHOTO);
			mesh.geometry = geometry;

			mesh.transform.appendTranslation(0, 0, 8);

			_view.scene.addChild(mesh);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		protected function onEnterFrame(event:Event):void
		{
			mesh.transform.appendRotation(1, Vector3D.Y_AXIS, mesh.transform.position);
		}

		private var angle:Number = 45;
	}
}

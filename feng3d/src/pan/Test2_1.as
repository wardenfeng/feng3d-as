package pan
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import feng3d.containers.View3D;
	import feng3d.core.base.Geometry;
	import feng3d.entities.Mesh;
	import feng3d.utils.Cast;

	/**
	 *
	 * @author warden_feng 2014-3-27
	 */
	[SWF(width = "640", height = "480", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class Test2_1 extends Sprite
	{
		private var _view:View3D;

		public var mesh:Mesh;

		public function Test2_1()
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
			_view.camera.projectionmatrix.perspectiveFieldOfViewLH(angle * Math.PI / 180, stage.stageWidth / stage.stageHeight, 0.01, 10000.0);
//			_view.camera.projectionmatrix.lookAtLH(new Vector3D(0,0,-2),new Vector3D(),new Vector3D(0,1,0));
			addChild(_view);

			var geometry:Geometry = new Geometry();

			geometry.rawIndexBuffer = Vector.<uint>([ //
				0, 1, 2, //
				]);
			geometry.rawPositionsBuffer = Vector.<Number>([
				//X,  Y,  Z		
				0, 0, 2, //
				0, 1, 2, //
				1, 0.5, 2, //
				]);
			geometry.rawUvBuffer = Vector.<Number>([
				//U, V	
				0, 0, //
				1, 0, //
				1, 1, //
				]);

			mesh = new Mesh();
			mesh.bitmapTexture = Cast.bitmapTexture(Asset.TERRAIN_TEXTURE);
			mesh.geometry = geometry;

			_view.scene.addChild(mesh);
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
		}
		
		private var angle:Number = 90;
		
		protected function onMouseWheel(event:MouseEvent):void
		{
			angle += event.delta;
			
			_view.camera.projectionmatrix.perspectiveFieldOfViewLH(angle * Math.PI / 180, stage.stageWidth / stage.stageHeight, 0.01, 10000.0);
			trace(angle);
		}
	}
}

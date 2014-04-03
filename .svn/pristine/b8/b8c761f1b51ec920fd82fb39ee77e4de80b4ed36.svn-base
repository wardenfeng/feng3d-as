package pan
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import feng3d.containers.View3D;
	import feng3d.core.base.Geometry;
	import feng3d.entities.Mesh;
	import feng3d.utils.Cast;

	/**
	 *
	 * @author warden_feng 2014-3-27
	 */
	[SWF(width = "640", height = "480", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class Test2_2 extends Sprite
	{
		private var _view:View3D;

		public var mesh:Mesh;

		public function Test2_2()
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
			addChild(_view);

			var geometry:Geometry = new Geometry();

			geometry.rawIndexBuffer = Vector.<uint>([ //
				0, 1, 2, //
				0, 2, 3, //
				]);
			geometry.rawPositionsBuffer = Vector.<Number>([
				//X,  Y,  Z		
				-1, 1, 3, //
				1, 1, 3, //
				1, -1, 3, //
				-1, -1, 3, //
				]);
			geometry.rawUvBuffer = Vector.<Number>([
				//U, V	
				0, 0, //
				2, 0, //
				2, 2, //
				0, 2,]);

			mesh = new Mesh();
			mesh.bitmapTexture = Cast.bitmapTexture(Asset.TERRAIN_TEXTURE);
			mesh.geometry = geometry;

			_view.scene.addChild(mesh);
			
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			for (var i:int = 1; i < mesh.geometry.rawUvBuffer.length; i+=2) 
			{
				mesh.geometry.rawUvBuffer[i] += 0.01;
			}
		}
		
		private var angle:Number = 45;
	}
}

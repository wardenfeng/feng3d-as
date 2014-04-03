package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;

	import feng3d.Feng3dData;
	import feng3d.containers.ObjectContainer3D;
	import feng3d.containers.View3D;
	import feng3d.core.base.Geometry;
	import feng3d.entities.Mesh;
	import feng3d.utils.Cast;

	/**
	 * (6)用四边形组成一个正方体并转动
	 * @author warden_feng 2014-3-27
	 */
	[SWF(width = "640", height = "640", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class TestCamera extends Sprite
	{
		private var _view:View3D;

		public var container3D:ObjectContainer3D;

		public function TestCamera()
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
			addChild(_view);
			_view.camera.projectionmatrix.perspectiveFieldOfViewLH(angle * Math.PI / 180, stage.stageWidth / stage.stageHeight, 0.01, 10000.0);

			container3D = new ObjectContainer3D();
			var geometry:Geometry = new Geometry();
			geometry.rawIndexBuffer = Vector.<uint>([ //
				0, 1, 2, //
				0, 2, 3, //
				]);
			geometry.rawPositionsBuffer = Vector.<Number>([
				//X,  Y,  Z		
				-1, 1, -1, //
				1, 1, -1, //
				1, -1, -1, //
				-1, -1, -1, //
				]);
			geometry.rawUvBuffer = Vector.<Number>([
				//U, V	
				0, 0, //
				1, 0, //
				1, 1, //
				0, 1, //
				]);

			var num:int = 4;
			for (var i:int = 0; i < num; i++)
			{
				var mesh:Mesh = new Mesh();
				mesh.bitmapTexture = Cast.bitmapTexture(Asset.imgList[i % Asset.imgList.length]);
				mesh.geometry = geometry;
				mesh.transform.appendRotation(360 / num * i, Vector3D.Y_AXIS);
				container3D.addChild(mesh);
			}

			container3D.transform.appendTranslation(0, 0, 8);

			_view.scene.addChild(container3D);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		private var cameraZ:Number = 0;

		protected function onMouseWheel(event:MouseEvent):void
		{
			_view.camera.z += event.delta/10;
			trace("照相机位置",_view.camera.sceneTransform.position)
		}

		protected function onEnterFrame(event:Event):void
		{
			container3D.transform.appendRotation(1, Vector3D.Y_AXIS, container3D.transform.position);
//			_view.camera.lookAt(new Vector3D(0, 0, 8));
		}

		private var angle:Number = 45;
	}
}

package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import me.feng3d.containers.ObjectContainer3D;
	import me.feng3d.containers.View3D;
	
	import model3d.PhotoBox;

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

			_view = new View3D();
			addChild(_view);

			//setup the camera
			_view.camera.z = -300;
			_view.camera.y = 100;
			_view.camera.lookAt(new Vector3D());
			
			container3D = new PhotoBox();
			_view.scene.addChild(container3D);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		protected function onMouseWheel(event:MouseEvent):void
		{
			_view.camera.z += event.delta;
			trace("摄像机位置",_view.camera.sceneTransform.position)
		}

		protected function onEnterFrame(event:Event):void
		{
			container3D.rotationY++;
//			container3D.transform.appendRotation(1, Vector3D.Y_AXIS, container3D.transform.position);
		}
	}
}

package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;

	import me.feng3d.containers.Container3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.test.TestBase;

	import model3d.PhotoBox;

	/**
	 * (6)用四边形组成一个正方体并转动
	 * @author feng 2014-3-27
	 */
	[SWF(width = "640", height = "640", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class TestCamera extends TestBase
	{
		private var _view:View3D;

		public var container3D:Container3D;

		public function TestCamera()
		{
			resourceList = [];
			super();
		}

		/**
		 * Global initialise function
		 */
		public function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			_view = new View3D();
			addChild(_view);

			//setup the camera
			_view.camera.transform3D.z = -300;
			_view.camera.transform3D.y = 100;
			_view.camera.transform3D.lookAt(new Vector3D());

			container3D = new PhotoBox(rootPath);
			_view.scene.addChild(container3D);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		protected function onMouseWheel(event:MouseEvent):void
		{
			_view.camera.transform3D.z += event.delta;
			trace("摄像机位置", _view.camera.sceneTransform.position)
		}

		protected function onEnterFrame(event:Event):void
		{
			container3D.transform3D.rotationY++;
//			container3D.transform.appendRotation(1, Vector3D.Y_AXIS, container3D.transform.position);

			_view.render();
		}
	}
}

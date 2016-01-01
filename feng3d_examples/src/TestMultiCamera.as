package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;

	import me.feng3d.cameras.Camera3D;
	import me.feng3d.containers.ObjectContainer3D;
	import me.feng3d.containers.View3D;
	import me.feng3d.test.TestBase;

	import model3d.PhotoBox;

	/**
	 * 测试多视角
	 * @author feng 2014-3-27
	 */
	[SWF(width = "640", height = "640", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class TestMultiCamera extends TestBase
	{
		private var _view:View3D;
		private var view1:View3D;

		public var container3D:ObjectContainer3D;

		public var camera1:Camera3D;
		public var camera2:Camera3D;

		public function TestMultiCamera()
		{
			super();
		}

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

			camera1 = _view.camera;

			camera2 = new Camera3D();
			camera2.transform3D.y = 300;
			camera2.transform3D.z = 100;
			camera2.transform3D.lookAt(new Vector3D());

			view1 = new View3D(_view.scene, camera2);
			addChild(view1);
			view1.width = view1.height = 100;
			view1.x = stage.stageWidth - view1.width;
			view1.backgroundColor = 0x666666;

			container3D = new PhotoBox(rootPath);
			_view.scene.addChild(container3D);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		protected function onMouseWheel(event:MouseEvent):void
		{
			_view.camera.transform3D.z += event.delta;
		}

		protected function onEnterFrame(event:Event):void
		{
			container3D.transform3D.rotationY++;
			_view.render();
		}
	}
}

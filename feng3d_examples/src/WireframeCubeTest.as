package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;

	import me.feng3d.containers.View3D;
	import me.feng3d.debug.Trident;
	import me.feng3d.primitives.WireframeCube;
	import me.feng3d.test.TestBase;

	/**
	 * 测试线框立方体
	 * @author feng 2014-4-9
	 */
	[SWF(width = "640", height = "360", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class WireframeCubeTest extends TestBase
	{
		public var _view:View3D;

		private var wireframeCube:WireframeCube;

		public function WireframeCubeTest()
		{
			super();
		}

		public function init():void
		{
			stage.frameRate = 60;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			_view = new View3D();
			addChild(_view);

			//setup the camera
			_view.camera.z = 200;
			_view.camera.y = 200;
			_view.camera.x = 200;
			_view.camera.lookAt(new Vector3D());

			//添加坐标系
			_view.scene.addChild(new Trident());

			//添加线框立方体
			wireframeCube = new WireframeCube(300, 300);
			_view.scene.addChild(wireframeCube);

			addEventListener(Event.ENTER_FRAME, _onEnterFrame);

			stage.addEventListener(MouseEvent.CLICK, onClick);
		}

		protected function onClick(event:MouseEvent):void
		{
			var colors:Array = [0xff0000, 0x00ff00, 0x0000ff, 0xffff00];

			wireframeCube.color = colors[int(colors.length * Math.random())];
		}

		/**
		 * render loop
		 */
		private function _onEnterFrame(e:Event):void
		{
			wireframeCube.rotationY++;

			_view.render();
		}
	}
}

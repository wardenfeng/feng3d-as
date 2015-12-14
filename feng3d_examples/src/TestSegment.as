package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	import me.feng3d.containers.View3D;
	import me.feng3d.debug.Trident;
	import me.feng3d.entities.SegmentSet;
	import me.feng3d.primitives.data.Segment;
	import me.feng3d.test.TestBase;

	/**
	 * 测试线段
	 * @author feng 2014-4-9
	 */
	[SWF(width = "640", height = "360", frameRate = "60", backgroundColor = "#FFFFFF")]
	public class TestSegment extends TestBase
	{
		public var _view:View3D;

		public var trident:Trident;

		public function TestSegment()
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
			trident = new Trident();

			//添加3条线段
			var segmentSet:SegmentSet = new SegmentSet();
			var segmentX:Segment = new Segment(new Vector3D(0, 0, 50), new Vector3D(0, 50, 0), 0xffff00, 0xffff00, 1);
			segmentSet.addSegment(segmentX);
			var segmentY:Segment = new Segment(new Vector3D(0, 50, 0), new Vector3D(50, 0, 0), 0xffff00, 0xffff00, 1);
			segmentSet.addSegment(segmentY);
			var segmentZ:Segment = new Segment(new Vector3D(50, 0, 0), new Vector3D(0, 0, 50), 0xffff00, 0xffff00, 1);
			segmentSet.addSegment(segmentZ);

			trident.addChild(segmentSet);
			_view.scene.addChild(trident);

			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}

		/**
		 * render loop
		 */
		private function _onEnterFrame(e:Event):void
		{
			trident.rotationY++;

			_view.render();
		}
	}
}

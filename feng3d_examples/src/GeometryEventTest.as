package
{
	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.events.GeometryEvent;
	import me.feng3d.test.TestBase;

	/**
	 * 测试Geometry事件冒泡
	 * @author feng 2014-12-18
	 */
	public class GeometryEventTest extends TestBase
	{
		public function GeometryEventTest()
		{

		}

		public function init():void
		{
			var geom:Geometry = new Geometry();
			var subGeom:SubGeometry = new SubGeometry();
			geom.addSubGeometry(subGeom);

			geom.addEventListener(GeometryEvent.SHAPE_CHANGE, onBoundsInvalid);
			subGeom.addEventListener(GeometryEvent.SHAPE_CHANGE, onBoundsInvalid);


			subGeom.dispatchEvent(new GeometryEvent(GeometryEvent.SHAPE_CHANGE, null, true));
		}

		private function onBoundsInvalid(event:GeometryEvent):void
		{
			trace(event.currentTarget, event.toString());
		}
	}
}

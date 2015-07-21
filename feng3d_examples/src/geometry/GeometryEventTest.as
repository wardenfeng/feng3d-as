package geometry
{
	import flash.display.Sprite;

	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.events.GeometryEvent;

	/**
	 * 测试Geometry事件冒泡
	 * @author warden_feng 2014-12-18
	 */
	public class GeometryEventTest extends Sprite
	{
		public function GeometryEventTest()
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

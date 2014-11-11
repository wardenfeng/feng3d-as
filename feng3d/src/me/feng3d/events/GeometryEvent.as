package me.feng3d.events
{
	import me.feng.events.FEvent;
	import me.feng3d.core.base.ISubGeometry;

	/**
	 *
	 * @author warden_feng 2014-5-15
	 */
	public class GeometryEvent extends FEvent
	{
		public static const SUB_GEOMETRY_ADDED:String = "SubGeometryAdded";

		public static const SUB_GEOMETRY_REMOVED:String = "SubGeometryRemoved";

		public static const BOUNDS_INVALID:String = "BoundsInvalid";

		private var _subGeometry:ISubGeometry;

		public function GeometryEvent(type:String, subGeometry:ISubGeometry = null, bubbles:Boolean = false)
		{
			super(type, subGeometry, bubbles);
			_subGeometry = subGeometry;
		}

		public function get subGeometry():ISubGeometry
		{
			return _subGeometry;
		}
	}
}

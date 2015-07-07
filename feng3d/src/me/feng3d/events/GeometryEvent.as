package me.feng3d.events
{
	import me.feng.events.FEvent;
	import me.feng3d.core.base.subgeometry.SubGeometry;

	/**
	 * 几何体事件
	 * @author warden_feng 2014-5-15
	 */
	public class GeometryEvent extends FEvent
	{
		/** 添加子几何体 */
		public static const SUB_GEOMETRY_ADDED:String = "SubGeometryAdded";

		/** 溢出子几何体 */
		public static const SUB_GEOMETRY_REMOVED:String = "SubGeometryRemoved";

		/** 几何体外形发生改变 */
		public static const SHAPE_CHANGE:String = "shapeChange";

		private var _subGeometry:SubGeometry;

		public function GeometryEvent(type:String, subGeometry:SubGeometry = null, bubbles:Boolean = false)
		{
			super(type, subGeometry, bubbles);
			_subGeometry = subGeometry;
		}

		public function get subGeometry():SubGeometry
		{
			return _subGeometry;
		}
	}
}

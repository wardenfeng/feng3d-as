package me.feng3d.events
{
	import me.feng.events.FEvent;

	/**
	 * 几何体组件事件
	 * @author feng 2015-12-8
	 */
	public class GeometryComponentEvent extends FEvent
	{
		/**
		 * 获取几何体顶点数据
		 */
		public static const GET_VA_DATA:String = "getVAData";

		/**
		 * 改变几何体顶点数据事件
		 */
		public static const CHANGED_VA_DATA:String = "changedVAData";

		/**
		 * 改变顶点索引数据事件
		 */
		public static const CHANGED_INDEX_DATA:String = "changedIndexData";

		public function GeometryComponentEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}

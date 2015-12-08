package me.feng3d.events
{
	import me.feng.events.FEvent;

	/**
	 * 几何体组件事件
	 * @author feng 2015-12-8
	 */
	public class GeometryComponentEvent extends FEvent
	{
		public static const GET_VA_DATA:String = "getVAData";

		public function GeometryComponentEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}

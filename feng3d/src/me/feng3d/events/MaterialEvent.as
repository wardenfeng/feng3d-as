package me.feng3d.events
{
	import me.feng.events.FEvent;

	/**
	 * 材质事件
	 * @author feng 2014-9-9
	 */
	public class MaterialEvent extends FEvent
	{
		/** 添加pass */
		public static const PASS_ADDED:String = "passAdded";
		/** 移除pass */
		public static var PASS_REMOVED:String = "passRemoved";

		public function MaterialEvent(type:String, data:* = null, bubbles:Boolean = false)
		{
			super(type, data, bubbles);
		}
	}
}

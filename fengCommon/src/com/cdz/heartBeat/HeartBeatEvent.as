package com.cdz.heartBeat
{
	import me.feng.events.FEvent;

	/**
	 *
	 * @author cdz 2015-10-31
	 */
	public class HeartBeatEvent extends FEvent
	{
		/** 渲染心跳 */
		public static const RENDER_BEAT:String = "renderBeat";

		/** 逻辑心跳 */
		public static const LOGIC_BEAT:String = "logicBeat";

		/** 资源解析心跳 */
		public static const RESOURCE_PARSE_BEAT:String = "resourceParseBeat";

		/** 物理心跳 */
		public static const PHYSICS_BEAT:String = "physicsBeat";

		/** 鼠标检测心跳 */
		public static const MOUSE_CHECK_BEAT:String = "MouseCheckBeat";


		public function HeartBeatEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}

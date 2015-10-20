package me.feng3d.events
{
	import flash.events.Event;

	/**
	 * 3D舞台事件
	 * @author feng 2015-3-5
	 */
	public class Stage3DEvent extends Event
	{
		/** 3D环境被创建事件 */
		public static const CONTEXT3D_CREATED:String = "Context3DCreated";
		/** 3D环境被摧毁事件 */
		public static const CONTEXT3D_DISPOSED:String = "Context3DDisposed";
		/** 3D环境被重新创建事件 */
		public static const CONTEXT3D_RECREATED:String = "Context3DRecreated";
		/** 视窗有发生变化 */
		public static const VIEWPORT_UPDATED:String = "ViewportUpdated";

		/**
		 * 构建一个3D舞台事件
		 * @param type			事件的类型，可以作为 Event.type 访问。
		 * @param bubbles		确定 Event 对象是否参与事件流的冒泡阶段。默认值为 false。
		 */
		public function Stage3DEvent(type:String, bubbles:Boolean = false)
		{
			super(type, bubbles);
		}
	}
}

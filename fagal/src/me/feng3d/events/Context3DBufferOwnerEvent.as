package me.feng3d.events
{
	import me.feng.events.FEvent;


	/**
	 * 3D环境缓冲拥有者事件
	 * @author feng 2015-7-18
	 */
	public class Context3DBufferOwnerEvent extends FEvent
	{
		/**
		 * 添加3D环境缓冲事件
		 */
		public static const ADD_CONTEXT3DBUFFER:String = "addContext3DBuffer";

		/**
		 * 移除3D环境缓冲事件
		 */
		public static const REMOVE_CONTEXT3DBUFFER:String = "removeContext3DBuffer";

		/**
		 * 添加子项3D环境缓冲拥有者事件
		 */
		public static const ADDCHILD_CONTEXT3DBUFFEROWNER:String = "addChildContext3DBufferOwner";

		/**
		 * 移除子项3D环境缓冲拥有者事件
		 */
		public static const REMOVECHILD_CONTEXT3DBUFFEROWNER:String = "removeChildContext3DBufferOwner";

		/**
		 * 创建3D环境缓冲拥有者事件
		 * @param type 					事件的类型，可以作为 Event.type 访问。
		 * @param data					事件携带的数据
		 * @param bubbles 				确定 Event 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param cancelable 			确定是否可以取消 Event 对象。默认值为 false。
		 */
		public function Context3DBufferOwnerEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}

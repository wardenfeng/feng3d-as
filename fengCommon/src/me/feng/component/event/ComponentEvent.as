package me.feng.component.event
{
	import me.feng.events.FEvent;

	/**
	 * 组件事件
	 * @author feng 2015-12-2
	 */
	public class ComponentEvent extends FEvent
	{
		/**
		 * 添加子组件事件
		 */
		public static const ADDED_COMPONET:String = "addedComponet";

		/**
		 * 被组件容器添加事件
		 */
		public static const BE_ADDED_COMPONET:String = "beAddedComponet";

		/**
		 * 移除子组件事件
		 */
		public static const REMOVED_COMPONET:String = "removedComponet";

		/**
		 * 被容器删除事件
		 */
		public static const BE_REMOVED_COMPONET:String = "beRemovedComponet";

		public function ComponentEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}

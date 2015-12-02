package me.feng.component
{
	import me.feng.events.FEventDispatcher;
	import me.feng.utils.ClassUtils;

	/**
	 * 被添加到组件容器后触发
	 */
	[Event(name = "beAddedComponet", type = "me.feng.component.event.ComponentEvent")]

	/**
	 * 从组件容器被移除后触发
	 */
	[Event(name = "beRemovedComponet", type = "me.feng.component.event.ComponentEvent")]

	/**
	 * 组件基类
	 * <p>所有组件均从该类继承</p>
	 * @author feng 2015-5-6
	 */
	public class Component extends FEventDispatcher
	{
		private var _componentName:String;

		/**
		 * 创建组件
		 * @param componentName		组件名称
		 */
		public function Component()
		{
		}

		public function set componentName(value:String):void
		{
			_componentName = value;
		}

		/**
		 * 组件名称
		 */
		public function get componentName():String
		{
			_componentName ||= ClassUtils.getDefaultName(this);

			return _componentName;
		}
	}
}

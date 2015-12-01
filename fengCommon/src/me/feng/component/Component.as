package me.feng.component
{
	import me.feng.events.FEventDispatcher;

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
		public function Component(componentName:String)
		{
			_componentName = componentName;
		}

		/**
		 * 组件名称
		 */
		public function get componentName():String
		{
			return _componentName;
		}

	}
}

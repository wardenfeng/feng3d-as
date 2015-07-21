package me.feng.component
{
	import me.feng.events.FEventDispatcher;

	/**
	 * 组件基类
	 * <p>所有组件均从该类继承</p>
	 * @author warden_feng 2015-5-6
	 */
	public class Component extends FEventDispatcher
	{
		/**
		 * 组件名称
		 */
		public var componentName:String;

		public function Component()
		{
		}
	}
}

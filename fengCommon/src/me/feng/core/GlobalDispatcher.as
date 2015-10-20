package me.feng.core
{
	import me.feng.events.FEventDispatcher;

	/**
	 * 全局事件适配器
	 * @author feng
	 */
	public class GlobalDispatcher extends FEventDispatcher
	{
		private static var _instance:GlobalDispatcher;

		/**
		 * 创建一个全局事件适配器
		 * <p>此类为单例，只能构造一次，使用时请使用GlobalDispatcher.instance获取实例</p>
		 */
		public function GlobalDispatcher()
		{
			if (_instance)
				throw new Error("此类不允许外部创建，请用instance属性！");
			_instance = this;
		}

		/**
		 * 适配器实例
		 */
		public static function get instance():GlobalDispatcher
		{
			return _instance || new GlobalDispatcher();
		}
	}
}

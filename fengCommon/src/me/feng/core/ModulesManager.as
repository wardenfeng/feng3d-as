package me.feng.core
{
	import me.feng.core.GlobalDispatcher;

	/**
	 * 模块管理器
	 * @author feng
	 */
	public class ModulesManager
	{
		/**
		 * 全局事件
		 */
		protected static var dispatcher:GlobalDispatcher = GlobalDispatcher.instance;

		/**
		 * 创建一个模块
		 */
		public function ModulesManager()
		{

		}

		/**
		 * 初始化模块
		 */
		protected function init():void
		{

		}
	}
}

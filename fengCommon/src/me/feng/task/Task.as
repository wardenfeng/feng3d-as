package me.feng.task
{

	/**
	 * 任务模块类
	 * @includeExample TaskModuleTest.as
	 *
	 * @author feng 2015-5-27
	 */
	public class Task
	{
		private static var _isInit:Boolean = false;

		private static var taskManager:TaskManager;

		/**
		 * 模块是否初始化
		 */
		public static function get isInit():Boolean
		{
			return _isInit;
		}

		/**
		 * 初始化模块
		 */
		public static function init():void
		{
			taskManager || (taskManager = new TaskManager());
			_isInit = true;
		}
	}
}

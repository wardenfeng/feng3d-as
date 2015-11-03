package com.cdz.heartBeat
{

	/**
	 ** 心跳模块类
	 * @includeExample HeatBeatModuleTest.as
	 * @author cdz 2015-10-31
	 */
	public class HeartBeat
	{
		private static var heartBeatManager:HeartBeatManager;

		/**
		 * 初始化模块
		 */
		public static function init():void
		{
			heartBeatManager || (heartBeatManager = new HeartBeatManager());
		}
	}
}

package me.feng.task
{

	/**
	 * 任务状态
	 * @author feng 2015-6-16
	 */
	public class TaskStateType
	{
		/** 初始状态 */
		public static const STATE_INIT:int = 0;

		/** 任务正在执行 */
		public static const STATE_EXECUTING:int = 1;

		/** 任务已完成 */
		public static const STATE_COMPLETED:int = 2;
	}
}

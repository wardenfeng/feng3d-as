package me.feng.events.heartBeat
{
	import me.feng.events.FEvent;


	/**
	 *
	 * @author cdz 2015-10-31
	 */
	public class HeartBeatModuleEvent extends FEvent
	{
		/** 注册心跳类型 */
		public static const REGISTER_BEAT_TYPE:String = "registerBeatType";

		/** 注销心跳类型 */
		public static const UNREGISTER_BEAT_TYPE:String = "unregisterBeatType";

		/** 暂停一个心跳类型 */
		public static const SUSPEND_ONE_BEAT:String = "suspendOneBeat";

		/** 恢复心跳类型 */
		public static const RESUME_ONE_BEAT:String = "resumeOneBeat";

		/** 停止所有心跳 */
		public static const SUSPEND_All_BEAT:String = "suspendAllBeat";

		/** 停止所有心跳 */
		public static const RESUME_ALL_BEAT:String = "resumeAllBeat";

		/**
		 * 创建任务模块事件
		 * @param type 					事件的类型
		 * @param data					事件携带的数据
		 * @param bubbles 				确定 Event 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param cancelable 			确定是否可以取消 Event 对象。默认值为 false。
		 */
		public function HeartBeatModuleEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}

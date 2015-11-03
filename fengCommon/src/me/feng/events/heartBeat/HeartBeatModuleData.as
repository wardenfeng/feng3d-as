package me.feng.events.heartBeat
{

	/**
	 *
	 * @author cdz 2015-10-31
	 */
	public class HeartBeatModuleData
	{
		/**
		 * 心跳类型名称
		 * @see
		 */
		public var BeatType:String;

		/**
		 * 心跳时间间隔 单位毫秒
		 */
		public var Interval:Number;

		/**
		 *
		 * @param taskCollectionType			任务集合类型名称
		 * @param taskCollectionTypeClass		任务集合类型定义
		 */
		public function HeartBeatModuleData(BeatType:String, Interval:Number)
		{
			this.BeatType = BeatType;
			this.Interval = Interval;
		}
	}
}

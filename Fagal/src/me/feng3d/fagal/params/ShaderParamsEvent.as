package me.feng3d.fagal.params
{
	import me.feng.events.FEvent;


	/**
	 * 渲染参数事件
	 * @author warden_feng 2015-5-14
	 */
	public class ShaderParamsEvent extends FEvent
	{
		/**
		 * 获取取样标记
		 */
		public static const GET_SAMPLE_FLAGS:String = "getSampleFlags";

		/**
		 * 创建一个渲染参数事件 对象.
		 * @param type 					事件的类型，可以作为 Event.type 访问。
		 * @param data					事件携带的数据
		 * @param bubbles 				确定 Event 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param cancelable 			确定是否可以取消 Event 对象。默认值为 false。
		 */
		public function ShaderParamsEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}

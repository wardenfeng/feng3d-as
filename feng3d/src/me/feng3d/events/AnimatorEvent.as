package me.feng3d.events
{
	import me.feng.events.FEvent;
	
	/**
	 * 动画事件
	 * @author warden_feng 2014-5-27
	 */
	public class AnimatorEvent extends FEvent
	{
		
		/** 动画开始 */
		public static const START:String = "start";
		
		/** 周期完成 */
		public static const CYCLE_COMPLETE:String = "cycle_complete";
		
		public function AnimatorEvent(type:String, data:*=null, bubbles:Boolean=false)
		{
			super(type, data, bubbles);
		}
	}
}
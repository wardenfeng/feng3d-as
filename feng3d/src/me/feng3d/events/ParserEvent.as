package me.feng3d.events
{
	import me.feng.events.FEvent;
	
	/**
	 * 解析事件
	 * @author warden_feng 2014-5-16
	 */
	public class ParserEvent extends FEvent
	{
		public static const PARSE_COMPLETE:String = 'parseComplete';
		
		public static const READY_FOR_DEPENDENCIES:String = 'readyForDependencies';
		
		public function ParserEvent(type:String, data:*=null, bubbles:Boolean=false)
		{
			super(type, data, bubbles);
		}
	}
}
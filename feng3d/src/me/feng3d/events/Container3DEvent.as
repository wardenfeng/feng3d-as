package me.feng3d.events
{
	import me.feng.events.FEvent;
	
	
	/**
	 * 
	 * @author feng 2014-9-10
	 */
	public class Container3DEvent extends FEvent
	{
		public function Container3DEvent(type:String, data:*=null, bubbles:Boolean=false)
		{
			super(type, data, bubbles);
		}
	}
}
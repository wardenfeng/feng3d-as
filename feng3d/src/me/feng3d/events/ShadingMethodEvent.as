package me.feng3d.events
{
	import me.feng.events.FEvent;
	
	
	/**
	 * 
	 * @author warden_feng 2014-7-1
	 */
	public class ShadingMethodEvent extends FEvent
	{
		public static const SHADER_INVALIDATED:String = "ShaderInvalidated";
		
		public function ShadingMethodEvent(type:String, data:*=null, bubbles:Boolean=false)
		{
			super(type, data, bubbles);
		}
	}
}
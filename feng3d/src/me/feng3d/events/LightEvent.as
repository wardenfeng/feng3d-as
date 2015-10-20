package me.feng3d.events
{
	import me.feng.events.FEvent;


	/**
	 *
	 * @author feng 2015-5-28
	 */
	public class LightEvent extends FEvent
	{
		public static const CASTS_SHADOW_CHANGE:String = "castsShadowChange";

		public function LightEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}

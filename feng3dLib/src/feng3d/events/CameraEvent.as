package feng3d.events
{

	/**
	 *
	 * @author warden_feng 2014-3-19
	 */
	public class CameraEvent extends FengEvent
	{
		public function CameraEvent(type:String, data:* = null)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}

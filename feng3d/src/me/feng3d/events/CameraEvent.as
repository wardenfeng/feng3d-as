package me.feng3d.events
{
	import me.feng.events.FEvent;
	import me.feng3d.cameras.Camera3D;
	
	/**
	 * 摄像机事件
	 * @author warden_feng 2014-10-14
	 */
	public class CameraEvent extends FEvent
	{
		public static const LENS_CHANGED:String = "lensChanged";
		
		public function CameraEvent(type:String, camera:Camera3D = null, bubbles:Boolean=false)
		{
			super(type, data, bubbles);
		}
		
		public function get camera():Camera3D
		{
			return data as Camera3D;
		}
	}
}
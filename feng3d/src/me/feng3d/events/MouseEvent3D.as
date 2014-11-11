package me.feng3d.events
{
	import me.feng.events.FEvent;
	import me.feng3d.containers.ObjectContainer3D;
	import me.feng3d.core.pick.PickingCollisionVO;

	/**
	 * 3d鼠标事件
	 * @author warden_feng 2014-4-29
	 */
	public class MouseEvent3D extends FEvent
	{
		/**
		 * 单击
		 */
		public static const CLICK:String = "click3d";

		/**
		 * 鼠标移人对象
		 */
		public static const MOUSE_OVER:String = "mouseOver3d";

		/**
		 * 鼠标移出对象
		 */
		public static const MOUSE_OUT:String = "mouseOut3d";

		/**
		 * 鼠标在对象上移动
		 */
		public static const MOUSE_MOVE:String = "mouseMove3d";

		/**
		 * 鼠标在对象上双击
		 */
		public static const DOUBLE_CLICK:String = "doubleClick3d";

		/**
		 * 鼠标在对象上按下
		 */
		public static const MOUSE_DOWN:String = "mouseDown3d";

		/**
		 * 鼠标在对象上弹起
		 */
		public static const MOUSE_UP:String = "mouseUp3d";

		/**
		 * 鼠标在对象上滚轮滚动
		 */
		public static const MOUSE_WHEEL:String = "mouseWheel3d";

		/**
		 * 鼠标事件对象
		 */
		public var object:ObjectContainer3D;

		/**
		 * 相交数据
		 */
		public var collider:PickingCollisionVO;

		public function MouseEvent3D(type:String, data:* = null, bubbles:Boolean = true)
		{
			super(type, data, bubbles);
		}
	}
}

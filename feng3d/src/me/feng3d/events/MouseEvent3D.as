package me.feng3d.events
{
	import flash.events.Event;

	import me.feng.events.FEvent;
	import me.feng3d.containers.Container3D;
	import me.feng3d.core.pick.PickingCollisionVO;

	/**
	 * 3d鼠标事件
	 * @author feng 2014-4-29
	 * @see flash.events.MouseEvent
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
		public var object:Container3D;

		/**
		 * 相交数据
		 */
		public var collider:PickingCollisionVO;

		/**
		 * 创建一个3D鼠标事件
		 * @param data					事件携带的数据
		 * @param type 					事件的类型，可以作为 Event.type 访问。
		 * @param bubbles 				确定 Event 对象是否参与事件流的冒泡阶段。默认值为 false。
		 * @param cancelable 			确定是否可以取消 Event 对象。默认值为 false。
		 */
		public function MouseEvent3D(type:String, data:* = null, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			var cl:MouseEvent3D = super.clone() as MouseEvent3D;
			cl.object = object;
			cl.collider = cl.collider;
			return cl;
		}
	}
}

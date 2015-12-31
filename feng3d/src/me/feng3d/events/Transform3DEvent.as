package me.feng3d.events
{
	import me.feng.events.FEvent;
	import me.feng3d.core.base.data.Element3D;

	/**
	 * 3D对象事件(3D状态发生改变、位置、旋转、缩放)
	 * @author feng 2014-3-31
	 */
	public class Transform3DEvent extends FEvent
	{
		/**
		 * 平移
		 */
		public static const POSITION_CHANGED:String = "positionChanged";

		/**
		 * 旋转
		 */
		public static const ROTATION_CHANGED:String = "rotationChanged";

		/**
		 * 缩放
		 */
		public static const SCALE_CHANGED:String = "scaleChanged";

		/**
		 * 变换
		 */
		public static const TRANSFORM_CHANGED:String = "transformChanged";

		/**
		 * 场景变换矩阵发生变化
		 */
		public static const SCENETRANSFORM_CHANGED:String = "scenetransformChanged";

		/**
		 * 创建3D对象事件
		 * @param type			事件类型
		 * @param element3D		发出事件的3D元素
		 */
		public function Transform3DEvent(type:String, element3D:Element3D, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}

		/**
		 * 发出事件的3D元素
		 */
		public function get element3D():Element3D
		{
			return data as Element3D;
		}
	}
}

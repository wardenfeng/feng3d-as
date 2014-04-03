package feng3d.events
{
	import feng3d.core.Element3D;

	/**
	 * 3D元素事件(3D状态发生改变、位置、旋转、缩放)
	 * @author warden_feng 2014-3-31
	 */
	public class Element3DEvent extends FengEvent
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
		 * 变换状态
		 */
		public static const TRANSFORM_CHANGED:String = "transformChanged";

		public function Element3DEvent(type:String, element3D:Element3D)
		{
			super(type, data);
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

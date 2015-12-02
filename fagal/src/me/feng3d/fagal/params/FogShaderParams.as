package me.feng3d.fagal.params
{
	import me.feng.component.Component;

	/**
	 * 雾渲染参数
	 * @author warden_feng 2015-12-1
	 */
	public class FogShaderParams extends Component
	{
		/**
		 * 组件名称
		 */
		public static const NAME:String = "FogShaderParams";

		/**
		 * 是否渲染雾
		 */
		public var useFog:int;

		/**
		 * 雾渲染参数
		 */
		public function FogShaderParams()
		{
			super(NAME);
		}

		/**
		 * 初始化
		 */
		public function init():void
		{
			useFog = 0;
		}
	}
}

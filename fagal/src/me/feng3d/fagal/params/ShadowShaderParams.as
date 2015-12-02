package me.feng3d.fagal.params
{
	import me.feng.component.Component;


	/**
	 * 阴影渲染参数
	 * @author warden_feng 2015-12-1
	 */
	public class ShadowShaderParams extends Component
	{
		/**
		 * 组件名称
		 */
		public static const NAME:String = "ShadowShaderParams";

		//-----------------------------------------
		//		阴影渲染参数
		//-----------------------------------------

		/**
		 * 是否使用阴影映射函数
		 */
		public var usingShadowMapMethod:int;

		/**
		 * 是否使用点光源
		 */
		public var usePoint:int;

		/**
		 * 是否需要投影顶点坐标数据
		 */
		public var needsProjection:int;

		/**
		 * 使用近阴影渲染
		 */
		public var useNearShadowMap:int;

		/**
		 * 是否需要阴影寄存器
		 */
		public var needsShadowRegister:int;

		/**
		 * 阴影渲染参数
		 */
		public function ShadowShaderParams()
		{
			super(NAME);
		}

		/**
		 * 初始化
		 */
		public function init():void
		{
			usingShadowMapMethod = 0;
			usePoint = 0;
			needsProjection = 0;
			useNearShadowMap = 0;
			needsShadowRegister = 0;
		}
	}
}

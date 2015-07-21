package me.feng3d.fagal.params
{
	import me.feng.component.Component;

	/**
	 * 阴影映射渲染参数
	 * @author warden_feng 2015-6-23
	 */
	public class ShaderParamsShadowMap extends Component
	{
		/**
		 * 渲染参数名称
		 */
		public static const NAME:String = "shadowMapShaderParams";

		/**
		 * 是否使用阴影映射函数
		 */
		public var usingShadowMapMethod:int;

		/**
		 * 是否使用点光源
		 */
		public var usePoint:Boolean;

		/**
		 * 是否需要投影顶点坐标数据
		 */
		public var needsProjection:Boolean;

		/**
		 * 是否需要阴影寄存器
		 */
		public var needsShadowRegister:int;

		/**
		 * 创建阴影映射渲染参数
		 */
		public function ShaderParamsShadowMap()
		{
			componentName = NAME;
		}
	}
}

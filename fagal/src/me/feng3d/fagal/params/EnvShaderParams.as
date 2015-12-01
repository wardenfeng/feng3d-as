package me.feng3d.fagal.params
{
	import me.feng.component.Component;


	/**
	 * 环境渲染参数
	 * @author feng 2015-12-1
	 */
	public class EnvShaderParams extends Component
	{
		/**
		 * 组件名称
		 */
		public static const NAME:String = "ShaderParams";

		//-----------------------------------------
		//		
		//-----------------------------------------
		/**  */
		public var useEnvMapMethod:int;

		/**  */
		public var useEnvMapMask:int;

		public function EnvShaderParams()
		{
			super(NAME);
		}
	}
}

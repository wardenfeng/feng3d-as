package me.feng3d.fagal.params
{
	import me.feng.component.Component;

	/**
	 * war3渲染参数
	 * @author warden_feng 2015-5-1
	 */
	public class ShaderParamsWar3 extends Component
	{
		/**
		 * 渲染参数名称
		 */
		public static const NAME:String = "war3ShaderParams";

		//-----------------------------------------
		//		魔兽争霸地形渲染参数
		//-----------------------------------------
		/** 土壤纹理个数 */
		public var splatNum_war3Terrain:int;

		/**
		 * 创建一个war3渲染参数
		 */
		public function ShaderParamsWar3()
		{
			componentName = NAME;
		}
	}
}

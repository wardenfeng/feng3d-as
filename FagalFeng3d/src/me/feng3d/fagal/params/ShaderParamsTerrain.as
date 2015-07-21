package me.feng3d.fagal.params
{
	import me.feng.component.Component;

	/**
	 * 地形渲染参数
	 * @author warden_feng 2015-4-29
	 */
	public class ShaderParamsTerrain extends Component
	{
		/**
		 * 渲染参数名称
		 */
		public static const NAME:String = "terrainShaderParams";

		//-----------------------------------------
		//		地形渲染参数
		//-----------------------------------------
		/** 土壤纹理个数 */
		public var splatNum:int;

		/**
		 * 创建一个地形渲染参数
		 */
		public function ShaderParamsTerrain()
		{
			componentName = NAME;
		}

		/**
		 * 初始化
		 */
		public function init():void
		{
			splatNum = 0;
		}
	}
}

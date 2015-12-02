package me.feng3d.fagal.params
{
	import me.feng.component.Component;


	/**
	 * 魔兽争霸地形渲染参数
	 * @author feng 2015-12-1
	 */
	public class WarcraftShaderParams extends Component
	{
		//-----------------------------------------
		//		魔兽争霸地形渲染参数
		//-----------------------------------------
		/** 土壤纹理个数 */
		public var splatNum_war3Terrain:int;

		/**
		 * 魔兽争霸地形渲染参数
		 */
		public function WarcraftShaderParams()
		{
			super();
		}

		/**
		 * 初始化
		 */
		public function init():void
		{
			splatNum_war3Terrain = 0;
		}
	}
}

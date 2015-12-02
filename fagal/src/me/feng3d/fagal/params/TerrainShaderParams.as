package me.feng3d.fagal.params
{
	import me.feng.component.Component;


	/**
	 * 地形渲染参数
	 * @author warden_feng 2015-12-1
	 */
	public class TerrainShaderParams extends Component
	{
		//-----------------------------------------
		//		地形渲染参数
		//-----------------------------------------
		/** 土壤纹理个数 */
		public var splatNum:int;

		/**
		 * 地形渲染参数
		 */
		public function TerrainShaderParams()
		{
			super();
		}

		/**
		 * 初始化
		 */
		public function init():void
		{
			//
			splatNum = 0;
		}
	}
}

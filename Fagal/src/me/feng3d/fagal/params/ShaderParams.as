package me.feng3d.fagal.params
{
	import me.feng.component.ComponentContainer;

	/**
	 * 渲染参数
	 * @author warden_feng 2014-11-4
	 */
	public class ShaderParams extends ComponentContainer
	{
		/**
		 * 创建一个渲染参数
		 */
		public function ShaderParams()
		{
		}

		/**
		 * 初始化渲染参数
		 */
		public function initParams():void
		{
			for each (var shaderParam:Object in components)
			{
				if (shaderParam.hasOwnProperty("init"))
				{
					shaderParam["init"]();
				}
			}
		}

		/**
		 * 渲染前初始化
		 */
		public function preRun():void
		{
			for each (var shaderParam:Object in components)
			{
				if (shaderParam.hasOwnProperty("preRun"))
				{
					shaderParam["preRun"]();
				}
			}
		}
	}
}

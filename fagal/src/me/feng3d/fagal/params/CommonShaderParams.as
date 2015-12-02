package me.feng3d.fagal.params
{
	import me.feng.component.Component;

	/**
	 * 通用渲染参数
	 * @author warden_feng 2015-12-1
	 */
	public class CommonShaderParams extends Component
	{
		//-----------------------------------------
		//		通用渲染参数
		//-----------------------------------------
		/** 是否有漫反射贴图 */
		public var hasDiffuseTexture:int;

		/** 是否使用漫反射函数 */
		public var usingDiffuseMethod:int;

		public var useAmbientTexture:int;

		public var alphaThreshold:Number = 0;

		/** 是否需要uv坐标 */
		public var needsUV:int;

		/**
		 * 通用渲染参数
		 */
		public function CommonShaderParams()
		{
			super();
		}

		/**
		 * 初始化
		 */
		public function init():void
		{
			hasDiffuseTexture = 0;
			needsUV = 0;
		}
	}
}

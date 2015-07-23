package me.feng3d.fagal.methods
{
	import me.feng.error.AbstractClassError;
	import me.feng.error.AbstractMethodError;
	import me.feng3d.arcanefagal;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	use namespace arcanefagal;

	/**
	 * Fagal函数
	 * @author warden_feng 2014-10-23
	 */
	public class FagalMethod
	{
		protected var _shaderType:String;

		/**
		 * 构建一个Fagal函数
		 */
		public function FagalMethod()
		{
			AbstractClassError.check(this);
		}

		/**
		 * 渲染参数
		 */
		public function get shaderParams():ShaderParams
		{
			return FagalRE.instance.context3DCache.shaderParams;
		}

		/**
		 * 着色器类型
		 */
		public function get shaderType():String
		{
			return _shaderType;
		}

		/**
		 * 运行函数，产生agal代码，最核心部分
		 */
		public function runFunc():void
		{
			throw new AbstractMethodError();
		}
	}
}



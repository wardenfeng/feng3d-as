package me.feng3d.fagal.methods
{
	import me.feng3d.arcanefagal;
	import me.feng3d.core.buffer.Context3DCache;
	import me.feng3d.core.register.ShaderRegisterCache;
	import me.feng3d.fagal.FagalToken;
	import me.feng.utils.ClassUtils;

	use namespace arcanefagal;

	/**
	 * Fagal函数运行环境(FagalMethodRuntimeEnvironment)
	 * @author warden_feng 2014-10-24
	 */
	public class FagalRE
	{
		private static var _instance:FagalRE;

		private var _regCache:ShaderRegisterCache;
		private var _context3DCache:Context3DCache;

		private var agalCode:String = "";
		private var _shaderType:String;

		/**
		 * 创建一个Fagal函数运行环境
		 */
		public function FagalRE()
		{
			if (_instance)
				throw new Error("该类为单例");
			_instance = this;
		}

		/**
		 * 3D环境缓存类(方便调试与管理渲染操作)
		 */
		public function get context3DCache():Context3DCache
		{
			return _context3DCache;
		}

		public function set context3DCache(value:Context3DCache):void
		{
			_context3DCache = value;
		}

		/**
		 * 寄存器缓存
		 */
		arcanefagal function get regCache():ShaderRegisterCache
		{
			return ShaderRegisterCache.instance;
		}

		/**
		 * 运行Fagal函数
		 * @param agalMethod Fagal函数
		 */
		public function run(agalMethod:*):String
		{
			//Fagal函数类实例
			var agalMethodInstance:FagalMethod = ClassUtils.getInstance(agalMethod);
			//着色器类型
			_shaderType = agalMethodInstance.shaderType;
			//清除agal代码
			clearCode();
			//运行Fagal函数
			agalMethodInstance.runFunc();

			return agalCode;
		}

		/**
		 * 着色器类型
		 */
		public function get shaderType():String
		{
			return _shaderType;
		}

		/**
		 * 添加代码
		 */
		public function append(code:String):void
		{
			if (agalCode.length > 0 && agalCode.substr(-FagalToken.BREAK.length) != FagalToken.BREAK)
				agalCode += FagalToken.BREAK;
			agalCode += code + FagalToken.BREAK;
		}

		/**
		 * 清除agal代码
		 */
		private function clearCode():void
		{
			agalCode = "";
		}

		/**
		 * Fagal函数运行环境实例
		 */
		public static function get instance():FagalRE
		{
			return _instance || new FagalRE();
		}
	}
}

package me.feng3d.fagalRE
{
	import flash.utils.Dictionary;

	import me.feng.utils.ClassUtils;
	import me.feng3d.arcanefagal;
	import me.feng3d.core.buffer.Context3DCache;
	import me.feng3d.core.register.ShaderRegisterCache;
	import me.feng3d.fagal.FagalToken;
	import me.feng3d.fagal.methods.FagalMethod;

	use namespace arcanefagal;

	/**
	 * Fagal函数运行环境(FagalMethodRuntimeEnvironment)
	 * @author warden_feng 2014-10-24
	 */
	public class FagalRE
	{
		private static var _instance:FagalRE;

		private var _context3DCache:Context3DCache;

		private var agalCode:String = "";
		private var _shaderType:String;

		private var _space:FagalRESpace;

		public var runState:String;

		internal static var idDic:Dictionary = new Dictionary();

		/**
		 * 添加3d缓冲编号配置
		 * @param configs
		 */
		public static function addBufferID(configs:Array):void
		{
			for (var i:int = 0; i < configs.length; i++)
			{
				idDic[configs[i][0]] = configs[i];
			}
		}

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
		 * Fagal运行环境空间
		 */
		public function get space():FagalRESpace
		{
			return _space ||= new FagalRESpace();
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
		 * 运行Fagal函数
		 * @param agalMethod Fagal函数
		 */
		public static function runShader(vertexShader:*, fragmentShader:*):Object
		{
			return instance.runShader(vertexShader, fragmentShader);
		}

		public static const PRERUN:String = "preRun";
		public static const RUN:String = "run";

		/**
		 * Fagal寄存器中心
		 */
		private function get registerCenter():FagalRegisterCenter
		{
			return FagalRegisterCenter.instance;
		}

		/**
		 * 运行Fagal函数
		 * @param agalMethod Fagal函数
		 */
		public function runShader(vertexShader:*, fragmentShader:*):Object
		{
			//清理缓存
			FagalRegisterCenter.clear();
			ShaderRegisterCache.invalid();

			var result:Object = {};

			FagalRE.instance.runState = FagalRE.PRERUN;

			space.clear();
			//运行顶点渲染函数
			result.vertexCode = run(vertexShader);
			space.clear();
			//运行片段渲染函数
			result.fragmentCode = run(fragmentShader);


			logger("Compiling AGAL Code:");
			logger("--------------------");
			logger(result.debugVertexCode);
			logger("--------------------");
			logger(result.debugFragmentCode);

			logger("Compiling AGAL Code:");
			logger("--------------------");
			logger(result.vertexCode);
			logger("--------------------");
			logger(result.fragmentCode);


			return result;
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

			var agalCode1:String = agalCode;

			clearCode();
			space.requestRegisterValue();

			space.doCallLog();

			var agalCode2:String = agalCode;

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

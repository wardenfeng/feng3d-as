package me.feng3d.fagalRE
{
	import flash.utils.Dictionary;

	import me.feng.utils.ClassUtils;
	import me.feng3d.arcanefagal;
	import me.feng3d.core.buffer.Context3DCache;
	import me.feng3d.core.register.Register;
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

		private var _shaderType:String;

		private var _space:FagalRESpace;

		public var runState:String;

		/**
		 * 数据id字典
		 */
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
		public static function runShader(vertexShader:*, fragmentShader:*):FagalShaderResult
		{
			return instance.runShader(vertexShader, fragmentShader);
		}

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
		public function runShader(vertexShader:*, fragmentShader:*):FagalShaderResult
		{
			//清理缓存
			FagalRegisterCenter.clear();
			ShaderRegisterCache.invalid();

			var shaderResult:FagalShaderResult = new FagalShaderResult();

			//运行顶点渲染函数
			var vertexObj:Object = run(vertexShader);
			shaderResult.vertexFCode = vertexObj.fagal;
			shaderResult.vertexCode = vertexObj.agal;
			//运行片段渲染函数
			var fragmentObj:Object = run(fragmentShader);
			shaderResult.fragmentFCode = fragmentObj.fagal;
			shaderResult.fragmentCode = fragmentObj.agal;

			shaderResult.print();

			return shaderResult;
		}

		/**
		 * 运行Fagal函数
		 * @param agalMethod Fagal函数
		 */
		public function run(agalMethod:*):Object
		{
			//Fagal函数类实例
			var agalMethodInstance:FagalMethod = ClassUtils.getInstance(agalMethod);
			//着色器类型
			_shaderType = agalMethodInstance.shaderType;

			//运行Fagal函数
			var callLog:FagalCallLog = space.run(agalMethodInstance.runFunc);

			var agalCode1:String = callLog.doCallLog(Register.NAME);

			callLog.requestRegisterValue();

			var agalCode2:String = callLog.doCallLog(Register.VALUE);

			return {fagal: agalCode1, agal: agalCode2};
		}

		/**
		 * 着色器类型
		 */
		public function get shaderType():String
		{
			return _shaderType;
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

package me.feng3d.core.buffer
{
	import com.adobe.utils.AGALMiniAssembler;

	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import me.feng3d.fagal.FagalToken;
	import me.feng3d.debug.Debug;

	/**
	 * AGAL程序缓冲
	 * @author warden_feng 2014-8-20
	 */
	public class AGALProgram3DCache
	{
		/**
		 * 实例字典
		 */
		private static var _instanceDic:Dictionary = new Dictionary();

		/**
		 * 字符串与二进制字典
		 */
		private static var shaderByteCodeDic:Dictionary = new Dictionary();

		/**
		 * 当前3D环境
		 */
		private var _context3D:Context3D;

		/**
		 * 字符串与程序字典
		 */
		private var _program3Ds:Dictionary;
		/**
		 * 程序使用计数
		 */
		private var _usages:Dictionary;
		/**
		 * 程序与字符串字典
		 */
		private var _keys:Dictionary;

		/**
		 * 创建AGAL程序缓冲
		 * @param context3D			3D环境
		 */
		public function AGALProgram3DCache(context3D:Context3D)
		{
			if (_instanceDic[context3D])
				throw new Error("已经存在对应的实例，请使用GetInstance方法获取。");

			_instanceDic[context3D] = this;

			_context3D = context3D;

			_program3Ds = new Dictionary();
			_usages = new Dictionary();
			_keys = new Dictionary();
		}

		/**
		 * 获取AGAL程序缓冲实例
		 * @param context3D			3D环境
		 * @return					AGAL程序缓冲实例
		 */
		public static function getInstance(context3D:Context3D):AGALProgram3DCache
		{
			return _instanceDic[context3D] ||= new AGALProgram3DCache(context3D);
		}

		/**
		 * 销毁
		 */
		public function dispose():void
		{
			for (var key:String in _program3Ds)
				destroyProgram(key);

			_keys = null;
			_program3Ds = null;
			_usages = null;
		}

		/**
		 * 获取渲染程序
		 * @param oldProgram3D			原来的渲染程序
		 * @param vertexCode			顶点渲染代码
		 * @param fragmentCode			片段渲染代码
		 * @return						渲染程序
		 */
		public function getProgram3D(oldProgram3D:Program3D, vertexCode:String, fragmentCode:String):Program3D
		{
			var key:String = getKey(vertexCode, fragmentCode);
			var program:Program3D = _program3Ds[key];

			if (program == null)
			{
				program = _context3D.createProgram();

				var vertexByteCode:ByteArray = getVertexByteCode(vertexCode);
				var fragmentByteCode:ByteArray = getFragmentByteCode(fragmentCode);

				program.upload(vertexByteCode, fragmentByteCode);

				_program3Ds[key] = program;
				_keys[program] = key;
				_usages[program] = 0;
			}

			if (oldProgram3D != program)
			{
				if (oldProgram3D)
					freeProgram3D(oldProgram3D);
				_usages[program]++;
			}

			return program;
		}

		/**
		 * 获取片段渲染二进制
		 * @param fragmentCode		片段渲染代码
		 * @return					片段渲染二进制
		 */
		private function getFragmentByteCode(fragmentCode:String):ByteArray
		{
			var noCommentCode:String = filterComment(fragmentCode);
			return shaderByteCodeDic[fragmentCode] ||= new AGALMiniAssembler(Debug.agalDebug).assemble(Context3DProgramType.FRAGMENT, noCommentCode);
		}

		/**
		 * 获取顶点渲染二进制
		 * @param vertexCode		顶点渲染代码
		 * @return 					顶点渲染二进制
		 */
		private function getVertexByteCode(vertexCode:String):ByteArray
		{
			var noCommentCode:String = filterComment(vertexCode);
			return shaderByteCodeDic[vertexCode] ||= new AGALMiniAssembler(Debug.agalDebug).assemble(Context3DProgramType.VERTEX, noCommentCode);
		}

		/**
		 * 过滤代码中的注释
		 * @param code			渲染代码
		 * @return				没有注释的渲染代码
		 */
		private function filterComment(code:String):String
		{
//			return code;
			var codes:Array = code.split(FagalToken.BREAK);
			var line:String;
			var newCode:String = "";
			for (var i:int = 0; i < codes.length; i++)
			{
				line = codes[i];

				if (line.length > 0 && line.substr(0, FagalToken.COMMENT.length) != FagalToken.COMMENT)
				{
					if (newCode.length > 0 && newCode.substr(-FagalToken.BREAK.length) != FagalToken.BREAK)
						newCode += FagalToken.BREAK;
					newCode += line;
				}
			}
			return newCode;
		}

		/**
		 * 释放渲染程序
		 * @param program3D		被释放的渲染程序
		 */
		public function freeProgram3D(program3D:Program3D):void
		{
			_usages[program3D]--;
			if (_usages[program3D] == 0)
				destroyProgram(_keys[program3D]);
		}

		/**
		 * 销毁渲染程序
		 * @param key		渲染代码
		 */
		private function destroyProgram(key:String):void
		{
			_program3Ds[key].dispose();
			_program3Ds[key] = null;
			delete _program3Ds[key];
		}

		/**
		 * 获取渲染代码键值
		 * @param vertexCode			顶点渲染代码
		 * @param fragmentCode			片段渲染代码
		 * @return						渲染代码键值
		 */
		private function getKey(vertexCode:String, fragmentCode:String):String
		{
			return vertexCode + "---" + fragmentCode;
		}
	}
}

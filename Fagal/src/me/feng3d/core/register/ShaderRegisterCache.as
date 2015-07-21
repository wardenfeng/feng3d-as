package me.feng3d.core.register
{
	import flash.utils.Dictionary;

	import me.feng3d.arcanefagal;
	import me.feng3d.core.buffer.ConstantsDataType;
	import me.feng3d.core.buffer.Context3DBufferTypeManager;
	import me.feng3d.core.buffer.type.Context3DBufferType;

	use namespace arcanefagal;

	/**
	 * 渲染寄存器缓存
	 * @author warden_feng 2014-6-5
	 */
	public class ShaderRegisterCache
	{
		/* 实例 */
		private static var _instance:ShaderRegisterCache;
		/** 脏标记 */
		private static var _dirty:Boolean = true;

		/** 数据寄存器缓存 */
		private var _dataRegisterDic:Dictionary;

		/** 使用到的寄存器个数 */
		private var usedDataRegisterNum:int;

		/** 寄存器池字典 */
		private var registerPoolDic:Dictionary;

//		/** 寄存器配置 */
//		private const registerConfig:Array = //
//			[[RegisterType.VA, 8], //
//			[RegisterType.VC, 128], //
//			[RegisterType.VT, 8], //
//			[RegisterType.V, 8], //
//			[RegisterType.FS, 8], //
//			[RegisterType.FC, 28], //
//			[RegisterType.FT, 8], //
//			[RegisterType.OP, 1], //
//			[RegisterType.OC, 1], //
//			];

		/** AGAL2寄存器配置 */
		private const registerConfig:Array = //
			[[RegisterType.VA, 8], //
			[RegisterType.VC, 250], //
			[RegisterType.VT, 26], //
			[RegisterType.V, 10], //
			[RegisterType.FS, 8], //
			[RegisterType.FC, 64], //
			[RegisterType.FT, 16], //
			[RegisterType.OP, 1], //
			[RegisterType.OC, 1], //
			];

		/**
		 * 创建渲染寄存器缓存
		 */
		public function ShaderRegisterCache()
		{
			if (_instance)
				throw new Error("ShaderRegisterCache 单例");
			_instance = this;

			init();
		}

		/**
		 * 初始化
		 */
		private function init():void
		{
			_dataRegisterDic = new Dictionary();
			registerPoolDic = new Dictionary();
			usedDataRegisterNum = 0;

			for (var i:int = 0; i < registerConfig.length; i++)
			{
				registerPoolDic[registerConfig[i][0]] = new RegisterPool(registerConfig[i][0], registerConfig[i][1]);
			}
			_dirty = false;
		}

		/**
		 * 重置
		 */
		private function reset():void
		{
			_dataRegisterDic = new Dictionary();
			usedDataRegisterNum = 0;

			for each (var registerPool:RegisterPool in registerPoolDic)
			{
				registerPool.reset();
			}

			_dirty = false;
		}

		/**
		 * 获取单个寄存器
		 * @param registerType 寄存器类型
		 * @return 第一个寄存器
		 */
		private function getSingleRegister(registerType:String):Register
		{
			var registerPool:RegisterPool = registerPoolDic[registerType];
			var result:Register = registerPool.requestFreeRegister();
			return result;
		}

		/**
		 * 获取寄存器向量
		 * @param registerType 寄存器类型
		 * @param numRegister 寄存器数目
		 * @return
		 */
		private function getRegisterVector(registerType:String, numRegister:int):RegisterVector
		{
			var registerPool:RegisterPool = registerPoolDic[registerType];
			var result:RegisterVector = registerPool.requestFreeRegisters(numRegister);
			return result;
		}

		/**
		 * 获取寄存器矩阵
		 * @param registerType 寄存器类型
		 * @return
		 */
		private function getRegisterMatrix(registerType:String):RegisterMatrix
		{
			var registerPool:RegisterPool = registerPoolDic[registerType];
			var result:RegisterMatrix = registerPool.requestRegisterMatrix();
			return result;
		}

		/**
		 * 获取几个空闲的顶点临时寄存器（可重复使用）
		 * @param num 数量
		 * @return 寄存器名称数组
		 */
		public function getFreeVertexTemps(num:int):Vector.<Register>
		{
			var _vertexTempCache:RegisterPool = registerPoolDic[RegisterType.VT];
			return _vertexTempCache.getFreeTemps(num);
		}

		/**
		 * 获取一个空闲的顶点临时寄存器（可重复使用）
		 * @return 寄存器名称数组
		 */
		public function getFreeVertexTemp():Register
		{
			var _vertexTempCache:RegisterPool = registerPoolDic[RegisterType.VT];
			return _vertexTempCache.requestFreeRegister();
		}

		/**
		 * 获取几个空闲的片段临时寄存器（可重复使用）
		 * @param num 数量
		 * @return 寄存器名称数组
		 */
		public function getFreeFragmentTemps(num:int):Vector.<Register>
		{
			var _fragmentTempCache:RegisterPool = registerPoolDic[RegisterType.FT];
			return _fragmentTempCache.getFreeTemps(num);
		}

		/**
		 * 获取一个空闲的片段临时寄存器（可重复使用）
		 * @return 寄存器
		 */
		public function getFreeFragmentTemp():Register
		{
			var _fragmentTempCache:RegisterPool = registerPoolDic[RegisterType.FT];
			return _fragmentTempCache.requestFreeRegister();
		}

		/**
		 * 回收不需要再使用的临时寄存器
		 * @param register 不需要再使用的临时寄存器
		 */
		arcanefagal function removeTempUsage(register:Register):void
		{
			if (!register)
				return;
			if (register.regType != RegisterType.FT && register.regType != RegisterType.VT)
			{
				throw new Error("非临时寄存器无法被回收");
			}
			var _fragmentTempCache:RegisterPool = registerPoolDic[register.regType];
			_fragmentTempCache.removeUsage(register);
		}

		/**
		 * 回收不需要再使用的临时寄存器数组
		 * @param ftTemps 不需要再使用的临时寄存器数组
		 */
		public function removeTempUsages(ftTemps:Vector.<Register>):void
		{
			for (var i:int = 0; i < ftTemps.length; i++)
			{
				removeTempUsage(ftTemps[i]);
			}
		}

		/**
		 * 申请数据寄存器
		 * @param dataType 数据类型
		 * @param numRegister 寄存器的个数(默认1个)
		 * @return 数据寄存器
		 */
		arcanefagal function requestRegister(dataTypeId:String, numRegister:int = 1):Register
		{
			if (_dataRegisterDic[dataTypeId])
				return _dataRegisterDic[dataTypeId];

			var bufferType:Context3DBufferType = Context3DBufferTypeManager.getBufferType(dataTypeId);

			var registerType:String = bufferType.registerType;

			var register:Register;
			if (bufferType.dataType == ConstantsDataType.MATRIX)
			{
				//获取寄存器矩阵
				register = getRegisterMatrix(registerType);
			}
			else if (numRegister > 1)
			{
				//获取寄存器向量
				register = getRegisterVector(registerType, numRegister);
			}
			else
			{
				register = getSingleRegister(registerType);
			}

			register.regId = dataTypeId;
			_dataRegisterDic[dataTypeId] = register;
			usedDataRegisterNum++;
			return register;
		}

		/**
		 * 申请数据寄存器矩阵
		 * @param dataType 数据类型
		 * @param numRegister 寄存器的个数(默认1个)
		 * @return 数据寄存器
		 */
		arcanefagal function requestRegisterMatrix(dataTypeId:String):RegisterMatrix
		{
			if (_dataRegisterDic[dataTypeId])
				return _dataRegisterDic[dataTypeId];

			var bufferType:Context3DBufferType = Context3DBufferTypeManager.getBufferType(dataTypeId);

			var register:RegisterMatrix = getRegisterMatrix(bufferType.registerType);

			register.regId = dataTypeId;
			_dataRegisterDic[dataTypeId] = register;
			usedDataRegisterNum++;
			return register;
		}

		/**
		 * 申请数据寄存器向量
		 * @param dataType 数据类型
		 * @param numRegister 寄存器的个数(默认1个)
		 * @return 数据寄存器
		 */
		arcanefagal function requestRegisterVector(dataTypeId:String, numRegister:int):RegisterVector
		{
			if (_dataRegisterDic[dataTypeId])
				return _dataRegisterDic[dataTypeId];

			var bufferType:Context3DBufferType = Context3DBufferTypeManager.getBufferType(dataTypeId);

			var register:RegisterVector = getRegisterVector(bufferType.registerType, numRegister);

			register.regId = dataTypeId;
			_dataRegisterDic[dataTypeId] = register;
			usedDataRegisterNum++;
			return register;
		}

		/**
		 * 获取寄存器
		 * @param dataType 数据类型
		 * @return 数据寄存器
		 */
		public function getRegister(dataType:String):Register
		{
			return _dataRegisterDic[dataType];
		}

		/**
		 * 是否存在 dataType 类型寄存器
		 * @param dataType 数据类型
		 * @return
		 */
		public function hasReg(dataType:String):Boolean
		{
			return _dataRegisterDic[dataType] != null;
		}

		/**
		 * 注销
		 */
		public function dispose():void
		{
			for each (var registerPool:RegisterPool in registerPoolDic)
			{
				registerPool.dispose();
			}

			_dataRegisterDic = null;
			registerPoolDic = null;
		}

		/**
		 * 实例
		 */
		public static function get instance():ShaderRegisterCache
		{
			_instance || new ShaderRegisterCache();
			if (_dirty)
				_instance.reset();
			return _instance;
		}

		/**
		 * 使缓存失效
		 */
		public static function invalid():void
		{
			_dirty = true;
		}

		/**
		 * 数据寄存器缓存
		 */
		public function get dataRegisterDic():Dictionary
		{
			return _dataRegisterDic;
		}

	}
}



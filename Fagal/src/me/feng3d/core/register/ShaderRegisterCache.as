package me.feng3d.core.register
{
	import flash.utils.Dictionary;

	import me.feng3d.arcanefagal;
	import me.feng3d.fagalRE.FagalRegisterCenter;

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

		/**
		 * AGAL2寄存器配置
		 */
		private static const registerConfig:Array = //
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
		 * 回收不需要再使用的临时寄存器
		 * @param register 不需要再使用的临时寄存器
		 */
		arcanefagal function removeTempUsage(dataTypeId:String):void
		{
			var register:Register = FagalRegisterCenter.dataRegisterDic[dataTypeId];

			if (!register)
				return;
			if (register.regType != RegisterType.FT && register.regType != RegisterType.VT)
			{
				return;
			}
			var _fragmentTempCache:RegisterPool = registerPoolDic[register.regType];
			_fragmentTempCache.removeUsage(register);
		}

		/**
		 * 申请数据寄存器
		 * @param dataType 数据类型
		 * @param numRegister 寄存器的个数(默认1个)
		 * @return 数据寄存器
		 */
		arcanefagal function requestRegister(dataTypeId:String):void
		{
			if (_dataRegisterDic[dataTypeId])
				return;

			var register:Register = FagalRegisterCenter.dataRegisterDic[dataTypeId];

			var registerPool:RegisterPool = registerPoolDic[register.regType];
			var registerValue:RegisterValue = registerPool.requestFreeRegisters(register.regLen);

			registerValue.dataTypeId = register.regId;

			register.index = registerValue.index;

			_dataRegisterDic[dataTypeId] = registerValue;
			usedDataRegisterNum++;
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



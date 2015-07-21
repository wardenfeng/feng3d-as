package me.feng3d.core.register
{

	/**
	 * 寄存器池
	 * @author warden_feng 2014-6-9
	 */
	public class RegisterPool
	{
		private var _regType:String;
		private var _regCount:int;

		/** 使用中的寄存器数组 */
		private var usedRegisters:Array;

		/**
		 * 创建寄存器池
		 * @param regType 寄存器类型
		 * @param regCount 寄存器总数
		 */
		public function RegisterPool(regType:String, regCount:int)
		{
			_regType = regType;
			_regCount = regCount;

			init();
		}

		/**
		 * 寄存器总数
		 */
		public function get regCount():int
		{
			return _regCount;
		}

		/**
		 * 寄存器类型
		 */
		public function get regType():String
		{
			return _regType;
		}

		/**
		 * 初始化
		 */
		private function init():void
		{
			usedRegisters = [];
		}

		/**
		 * 获取临时寄存器数组
		 * @param num 寄存器数量
		 * @return 寄存器数组
		 */
		public function getFreeTemps(num:int):Vector.<Register>
		{
			var regNames:Vector.<Register> = new Vector.<Register>();
			for (var i:int = 0; i < num; i++)
			{
				var reg:Register = requestFreeRegister();
				regNames.push(reg);
			}
			return regNames;
		}

		/**
		 * 获取寄存器
		 * @param num 寄存器个数
		 */
		public function requestFreeRegisters(num:int):RegisterVector
		{
			var index:int = find(num);
			if (index == -1)
				throw new Error(_regType + "寄存器不够用!");
			var reg:RegisterVector = new RegisterVector(_regType, index, num);
			for (var i:int = 0; i < num; i++)
			{
				usedRegisters[index + i] = true;
			}
			return reg;
		}

		/**
		 * 获取寄存器
		 * @param num 寄存器个数
		 */
		public function requestRegisterMatrix():RegisterMatrix
		{
			var num:int = 4;

			var index:int = find(num);
			if (index == -1)
				throw new Error(_regType + "寄存器不够用!");
			var reg:RegisterMatrix = new RegisterMatrix(_regType, index);
			for (var i:int = 0; i < num; i++)
			{
				usedRegisters[index + i] = true;
			}
			return reg;
		}

		/**
		 * 获取寄存器
		 * @param numRegister 寄存器个数
		 */
		public function requestFreeRegister():Register
		{
			var index:int = find();
			if (index == -1)
				throw new Error(_regType + "寄存器不够用!");
			var reg:Register = new Register(_regType, index);
			usedRegisters[index] = true;
			return reg;
		}

		/**
		 * 移除使用寄存器
		 * @param register 寄存器
		 */
		public function removeUsage(register:Register):void
		{
			var start:int, last:int;
			start = last = register.index;

			//从使用中寄存器数组中删除
			var registerVector:RegisterVector = register as RegisterVector;
			var registerMatrix:RegisterMatrix = register as RegisterMatrix;
			if (registerVector)
			{
				last = registerVector.last.index;
			}

			for (var i:int = start; i <= last; i++)
			{
				usedRegisters[i] = false;
			}
		}

		public function dispose():void
		{
			usedRegisters = null;
		}

		public function reset():void
		{
			usedRegisters = [];
		}

		/**
		 * 寻找可用寄存器编号
		 * @param num 个数
		 * @return 如果找到返回非负值，未找到返回-1
		 */
		private function find(num:int = 1):int
		{
			var cNum:int = 0;
			for (var i:int = 0; i < _regCount; i++)
			{
				if (!usedRegisters[i])
					cNum++;
				else
					cNum = 0;
				if (cNum == num)
					return i - cNum + 1;
			}
			return -1;
		}
	}
}



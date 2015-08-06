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
		 * 获取寄存器
		 * @param num 寄存器个数
		 */
		public function requestFreeRegisters(num:int):RegisterValue
		{
			var index:int = find(num);
			if (index == -1)
				throw new Error(_regType + "寄存器不够用!");
			var reg:RegisterValue = new RegisterValue();
			reg.regType = _regType;
			reg.index = index;
			reg.length = num;

			for (var i:int = 0; i < num; i++)
			{
				usedRegisters[index + i] = true;
			}
			return reg;
		}

		/**
		 * 移除使用寄存器
		 * @param register 寄存器
		 */
		public function removeUsage(register:Register):void
		{
			for (var i:int = 0; i < register.regLen; i++)
			{
				usedRegisters[register.index + i] = false;
			}
		}

		/**
		 * 销毁
		 */
		public function dispose():void
		{
			usedRegisters = null;
		}

		/**
		 * 重置
		 */
		public function reset():void
		{
			usedRegisters = [];
		}

		/**
		 * 寻找连续可用寄存器编号
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



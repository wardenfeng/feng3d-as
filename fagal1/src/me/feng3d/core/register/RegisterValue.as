package me.feng3d.core.register
{

	/**
	 * 寄存器值
	 * @author feng 2015-7-30
	 */
	public class RegisterValue
	{
		/**
		 * 数据类型编号
		 */
		public var dataTypeId:String;

		/**
		 * 寄存器类型
		 */
		public var regType:String;

		/**
		 * 寄存器索引
		 */
		public var index:int;

		/**
		 * 寄存器长度
		 */
		public var length:int = 1;

		/**
		 * 输出为字符串
		 */
		public function toString():String
		{
			if (regType == RegisterType.OP || regType == RegisterType.OC)
				return regType;
			return regType + index;
		}
	}
}

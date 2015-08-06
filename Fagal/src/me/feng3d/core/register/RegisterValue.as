package me.feng3d.core.register
{

	/**
	 * 寄存器值
	 * @author warden_feng 2015-7-30
	 */
	public class RegisterValue
	{

		public var dataTypeId:String;

		/**
		 * 寄存器类型
		 */
		public var regType:String;

		public var index:int;

		public var num:int = 1;

		public function RegisterValue()
		{
		}

		public function toString():String
		{
			if (regType == RegisterType.OP || regType == RegisterType.OC)
				return regType;
			return regType + index;
		}
	}
}

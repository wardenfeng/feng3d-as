package me.feng3d.core.register
{
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 寄存器数组元素
	 * @author warden_feng 2014-11-3
	 */
	public class RegisterArrayItem extends Register
	{
		/**
		 * 数组编号
		 */
		protected var _arrayIndex:int;

		protected var _registerArray:RegisterArray;

		/**
		 * 创建一个寄存器数组元素
		 * @param registerArray			所属寄存器数组
		 * @param arrayIndex			所在寄存器数组中的索引
		 */
		public function RegisterArrayItem(registerArray:RegisterArray, arrayIndex:int)
		{
			super(registerArray.regId);

			_registerArray = registerArray;
			_arrayIndex = arrayIndex;
		}

		override public function toString():String
		{
			if (Register.TO_STRING == Register.NAME)
				return "{" + regId + "}[" + _arrayIndex + "]";

			if (_regType != RegisterType.OP && _regType != RegisterType.OC)
				return regType + (_arrayIndex + _registerArray.index);
			return _regType;
		}

	}
}

package me.feng3d.core.register
{
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 寄存器向量元素
	 * @author warden_feng 2014-11-3
	 */
	public class RegisterVectorItem extends Register
	{
		/**
		 * 数组编号
		 */
		protected var _arrayIndex:int;

		protected var _registerVector:RegisterVector;

		public function RegisterVectorItem(registerVector:RegisterVector, arrayIndex:int)
		{
			super(registerVector.regId);

			_registerVector = registerVector;
			_arrayIndex = arrayIndex;
		}

		override public function toString():String
		{
			if (FagalRE.instance.runState == FagalRE.PRERUN)
				return "{" + regId + "}[" + _arrayIndex + "]";

			if (_regType != RegisterType.OP && _regType != RegisterType.OC)
				return regType + (_arrayIndex + _registerVector.index);
			return _regType;
		}

	}
}

package me.feng3d.core.register
{
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 寄存器向量元素
	 * @author warden_feng 2014-11-3
	 */
	public class RegisterVectorComplexItem extends RegisterVectorItem
	{
		private var _complexArgs:Array;

		public function RegisterVectorComplexItem(registerVector:RegisterVector, complexArgs:Array, arrayIndex:int)
		{
			_complexArgs = complexArgs;

			super(registerVector, arrayIndex);
		}

		public function get complexArgs():Array
		{
			return _complexArgs;
		}

		override public function toString():String
		{
			var _numStr:String = _complexArgs.join("+");

			if (FagalRE.instance.runState == FagalRE.PRERUN)
				return "{" + regId + "}[" + _numStr + "+" + _arrayIndex + "]";

			if (_regType != RegisterType.OP && _regType != RegisterType.OC)
				return regType + "[" + _numStr + "+" + (_arrayIndex + _registerVector.index) + "]";
			return _regType;
		}
	}
}

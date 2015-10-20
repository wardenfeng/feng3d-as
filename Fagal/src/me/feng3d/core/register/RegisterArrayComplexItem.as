package me.feng3d.core.register
{
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 寄存器数组复杂元素
	 * @author feng 2014-11-3
	 */
	public class RegisterArrayComplexItem extends RegisterArrayItem
	{
		private var _complexArgs:Array;

		/**
		 * 创建一个寄存器数组复杂元素
		 * @param registerArray			所属寄存器数组
		 * @param complexArgs			复杂参数（用来计算所在寄存器数组中的索引值）
		 * @param arrayIndex			起始索引值
		 */
		public function RegisterArrayComplexItem(registerArray:RegisterArray, complexArgs:Array, startIndex:int)
		{
			_complexArgs = complexArgs;

			super(registerArray, startIndex);
		}

		/**
		 * 复杂参数（用来计算所在寄存器数组中的索引值）
		 */
		public function get complexArgs():Array
		{
			return _complexArgs;
		}

		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			var _numStr:String = _complexArgs.join("+");

			if (Register.TO_STRING == Register.NAME)
				return regId + "[" + _numStr + "+" + _arrayIndex + "]";

			if (_regType != RegisterType.OP && _regType != RegisterType.OC)
				return regType + "[" + _numStr + "+" + (_arrayIndex + _registerArray.index) + "]";
			return _regType;
		}
	}
}

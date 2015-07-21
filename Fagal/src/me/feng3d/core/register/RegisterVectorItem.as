package me.feng3d.core.register
{

	/**
	 * 寄存器向量元素
	 * @author warden_feng 2014-11-3
	 */
	public class RegisterVectorItem extends Register
	{
		public function RegisterVectorItem(reg:Register, numStr:String, num:int)
		{
			super(reg.regType, 0);
			_toStr = regType + "[" + numStr + "+" + (num + reg.index) + "]";
		}

		override public function get index():int
		{
			throw new Error("index是个变量，无固定值");
		}
	}
}

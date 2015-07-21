package me.feng3d.core.register
{

	/**
	 * 寄存器矩阵
	 * @author warden_feng 2014-11-4
	 */
	public class RegisterMatrix extends RegisterVector
	{
		public function RegisterMatrix(regType:String, start:int)
		{
			super(regType, start, 4);
		}
	}
}
package me.feng3d.core.buffer.context3d
{

	/**
	 * Context3D关联寄存器的数据缓存
	 * @author warden_feng 2014-8-14
	 */
	public class RegisterBuffer extends Context3DBuffer
	{
		/** 需要寄存器的个数 */
		public var numRegisters:int = 1;

		/** 要设置的首个寄存器的索引 */
		public var firstRegister:int;

		/**
		 * 创建寄存器数据缓存
		 * @param dataTypeId 		数据编号
		 * @param updateFunc 		数据更新回调函数
		 */
		public function RegisterBuffer(dataTypeId:String, updateFunc:Function)
		{
			super(dataTypeId, updateFunc);
		}
	}
}

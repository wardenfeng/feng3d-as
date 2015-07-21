package me.feng3d.core.buffer.context3d
{
	import me.feng3d.core.register.Register;

	/**
	 * Context3D关联寄存器的数据缓存
	 * @author warden_feng 2014-8-14
	 */
	public class RegisterBuffer extends Context3DBuffer
	{
		/** 需要寄存器的个数 */
		public var numRegisters:int = 1;

		/** 数据对应的寄存器 */
		public var shaderRegister:Register;

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

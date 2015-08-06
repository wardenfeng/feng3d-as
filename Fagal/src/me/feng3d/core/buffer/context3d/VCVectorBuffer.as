package me.feng3d.core.buffer.context3d
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;

	import me.feng3d.arcanefagal;
	import me.feng3d.debug.assert;

	use namespace arcanefagal;

	/**
	 * Context3D 顶点向量常量数据缓存
	 * @author warden_feng 2014-8-20
	 */
	public class VCVectorBuffer extends ConstantsBuffer
	{
		/** 静态向量数据 */
		public var data:Vector.<Number>;

		public function VCVectorBuffer(dataTypeId:String, updateFunc:Function)
		{
			super(dataTypeId, updateFunc);
		}

		override arcanefagal function doBuffer(context3D:Context3D):void
		{
			doUpdateFunc();

			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, firstRegister, data, numRegisters);
		}

		public function update(data:Vector.<Number>, numRegisters:int = -1):void
		{
			assert(data.length % 4 == 0, "常量数据个数必须为4的倍数！");

			this.data = data;
			this.numRegisters = numRegisters;
		}
	}
}

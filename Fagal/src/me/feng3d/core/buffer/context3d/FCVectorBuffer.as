package me.feng3d.core.buffer.context3d
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;

	import me.feng3d.arcanefagal;
	import me.feng3d.debug.assert;

	use namespace arcanefagal;

	/**
	 * Context3D 片段向量常量数据缓存
	 * @author warden_feng 2014-8-20
	 */
	public class FCVectorBuffer extends ConstantsBuffer
	{
		/** 常量向量数据 */
		arcanefagal var data:Vector.<Number>;

		/**
		 * 创建片段向量常量数据缓存
		 * @param dataTypeId 		数据编号
		 * @param updateFunc 		数据更新回调函数
		 */
		public function FCVectorBuffer(dataTypeId:String, updateFunc:Function)
		{
			super(dataTypeId, updateFunc);
		}

		/**
		 * @inheritDoc
		 */
		override arcanefagal function doBuffer(context3D:Context3D):void
		{
			doUpdateFunc();

			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, shaderRegister.index, data, numRegisters);
		}

		/**
		 * 更新数据
		 * @param data
		 * @param numRegisters
		 *
		 */
		public function update(data:Vector.<Number>, numRegisters:int = -1):void
		{
			assert(data.length % 4 == 0, "常量数据个数必须为4的倍数！");

			this.data = data;
			this.numRegisters = numRegisters;
		}
	}
}

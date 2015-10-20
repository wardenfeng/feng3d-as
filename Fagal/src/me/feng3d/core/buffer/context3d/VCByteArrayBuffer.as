package me.feng3d.core.buffer.context3d
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.utils.ByteArray;

	import me.feng3d.arcanefagal;

	use namespace arcanefagal;

	/**
	 * Context3D 顶点字节数组常量数据缓存
	 * @author feng 2014-8-20
	 */
	public class VCByteArrayBuffer extends ConstantsBuffer
	{
		private var data:ByteArray;

		/**
		 * 创建一个顶点字节数组常量数据缓存
		 * @param dataTypeId		数据编号
		 * @param updateFunc		数据更新回调函数
		 */
		public function VCByteArrayBuffer(dataTypeId:String, updateFunc:Function)
		{
			super(dataTypeId, updateFunc);
		}

		/**
		 * @inheritDoc
		 */
		override arcanefagal function doBuffer(context3D:Context3D):void
		{
			doUpdateFunc();

			context3D.setProgramConstantsFromByteArray(Context3DProgramType.VERTEX, firstRegister, 1, data, data.position);
		}
	}
}

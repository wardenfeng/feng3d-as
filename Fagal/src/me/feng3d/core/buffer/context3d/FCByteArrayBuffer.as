package me.feng3d.core.buffer.context3d
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.utils.ByteArray;

	import me.feng3d.arcanefagal;

	use namespace arcanefagal;

	/**
	 * Context3D 片段字节数组常量数据缓存
	 * @author warden_feng 2014-8-20
	 */
	public class FCByteArrayBuffer extends ConstantsBuffer
	{
		private var data:ByteArray;

		public function FCByteArrayBuffer(dataTypeId:String, updateFunc:Function)
		{
			super(dataTypeId, updateFunc);
		}

		override arcanefagal function doBuffer(context3D:Context3D):void
		{
			doUpdateFunc();

			context3D.setProgramConstantsFromByteArray(Context3DProgramType.FRAGMENT, shaderRegister.index, 1, data, data.position);
		}
	}
}

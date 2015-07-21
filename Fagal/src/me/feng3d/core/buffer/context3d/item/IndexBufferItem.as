package me.feng3d.core.buffer.context3d.item
{
	import flash.display3D.Context3D;
	import flash.display3D.IndexBuffer3D;

	/**
	 *
	 * @author warden_feng 2014-8-26
	 */
	public class IndexBufferItem
	{
		/** 是否无效 */
		public var invalid:Boolean = true;

		public var indexBuffer3D:IndexBuffer3D;

		public var context3D:Context3D;

		public function IndexBufferItem(context3D:Context3D,numIndices:int)
		{
			this.context3D = context3D;
			indexBuffer3D = context3D.createIndexBuffer(numIndices);
			invalid = true;
		}

		public function uploadFromVector(data:Vector.<uint>, startOffset:int, count:int):void
		{
			indexBuffer3D.uploadFromVector(data, startOffset, count);
			invalid = false;
		}

		public function drawTriangles(firstIndex:int = 0, numTriangles:int = -1):void
		{
			context3D.drawTriangles(indexBuffer3D, firstIndex, numTriangles);
		}

	}
}

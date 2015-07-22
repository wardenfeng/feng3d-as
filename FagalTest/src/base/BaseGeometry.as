package base
{
	import fagal.Context3DBufferTypeID;

	import me.feng3d.core.base.VertexBufferOwner;
	import me.feng3d.core.buffer.context3d.IndexBuffer;

	/**
	 *
	 * @author warden_feng 2014-10-27
	 */
	public class BaseGeometry extends VertexBufferOwner
	{
		protected var _indices:Vector.<uint>;

		protected var numIndices:uint;

		public function BaseGeometry()
		{
			super();
		}

		override protected function initBuffers():void
		{
			mapContext3DBuffer(Context3DBufferTypeID.INDEX, updateIndexBuffer);

			mapVABuffer(Context3DBufferTypeID.POSITION_VA_3, 3);
			mapVABuffer(Context3DBufferTypeID.COLOR_VA_3, 3);
		}

		protected function updateIndexBuffer(indexBuffer:IndexBuffer):void
		{
			indexBuffer.update(_indices, numIndices, numIndices);
		}

		public function setGeometry(positionData:Vector.<Number>, colorData:Vector.<Number>, indexData:Vector.<uint>):void
		{
			numVertices = positionData.length / 3;

			setVAData(Context3DBufferTypeID.POSITION_VA_3, positionData);
			setVAData(Context3DBufferTypeID.COLOR_VA_3, colorData);

			_indices = indexData;

			numIndices = _indices.length;
		}
	}
}

package base
{
	import me.feng3d.core.base.VertexBufferOwner;
	import me.feng3d.core.buffer.context3d.IndexBuffer;

	/**
	 *
	 * @author feng 2014-10-27
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
			mapContext3DBuffer(_.index, updateIndexBuffer);

			mapVABuffer(_.position_va_3, 3);
			mapVABuffer(_.color_va_3, 3);
		}

		protected function updateIndexBuffer(indexBuffer:IndexBuffer):void
		{
			indexBuffer.update(_indices, numIndices, numIndices);
		}

		public function setGeometry(positionData:Vector.<Number>, colorData:Vector.<Number>, indexData:Vector.<uint>):void
		{
			numVertices = positionData.length / 3;

			setVAData(_.position_va_3, positionData);
			setVAData(_.color_va_3, colorData);

			_indices = indexData;

			numIndices = _indices.length;
		}
	}
}

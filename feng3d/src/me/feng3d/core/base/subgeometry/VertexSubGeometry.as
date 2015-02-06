package me.feng3d.core.base.subgeometry
{
	import me.feng3d.core.buffer.Context3DBufferTypeID;

	/**
	 * 顶点动画 子网格
	 * @author warden_feng 2014-8-28
	 */
	public class VertexSubGeometry extends SubGeometry
	{
		public function VertexSubGeometry()
		{
			super();
		}

		override protected function initBuffers():void
		{
			super.initBuffers();

			mapVABuffer(Context3DBufferTypeID.POSITION0_VA_3, 3);
			mapVABuffer(Context3DBufferTypeID.POSITION1_VA_3, 3);
		}

		public function updateVertexData0(vertices:Vector.<Number>):void
		{
			super.updateVertexPositionData(vertices);
			setVAData(Context3DBufferTypeID.POSITION0_VA_3, vertices);
		}

		public function updateVertexData1(vertices:Vector.<Number>):void
		{
			setVAData(Context3DBufferTypeID.POSITION1_VA_3, vertices);
		}
	}
}

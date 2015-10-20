package me.feng3d.core.base.subgeometry
{
	

	/**
	 * 顶点动画 子网格
	 * @author feng 2014-8-28
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

			mapVABuffer(_.position0_va_3, 3);
			mapVABuffer(_.position1_va_3, 3);
		}

		public function updateVertexData0(vertices:Vector.<Number>):void
		{
			super.updateVertexPositionData(vertices);
			setVAData(_.position0_va_3, vertices);
		}

		public function updateVertexData1(vertices:Vector.<Number>):void
		{
			setVAData(_.position1_va_3, vertices);
		}
	}
}

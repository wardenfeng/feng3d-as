package me.feng3d.components.subgeometry
{
	import me.feng.component.event.ComponentEvent;

	/**
	 * 顶点动画 子网格
	 * @author feng 2014-8-28
	 */
	public class VertexSubGeometry extends SubGeometryComponent
	{
		public function VertexSubGeometry()
		{
			super();
		}

		/**
		 * 处理被添加事件
		 * @param event
		 */
		override protected function onBeAddedComponet(event:ComponentEvent):void
		{
			super.onBeAddedComponet(event);

			subGeometry.mapVABuffer(_.position0_va_3, 3);
			subGeometry.mapVABuffer(_.position1_va_3, 3);

			updateVertexData0(subGeometry.vertexPositionData.concat());
			updateVertexData1(subGeometry.vertexPositionData.concat());
		}

		public function updateVertexData0(vertices:Vector.<Number>):void
		{
			subGeometry.updateVertexPositionData(vertices);
			subGeometry.setVAData(_.position0_va_3, vertices);
		}

		public function updateVertexData1(vertices:Vector.<Number>):void
		{
			subGeometry.setVAData(_.position1_va_3, vertices);
		}
	}
}

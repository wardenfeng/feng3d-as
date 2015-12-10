package me.feng3d.components.subgeometry
{
	import me.feng.component.Component;
	import me.feng.component.event.ComponentEvent;
	import me.feng.component.event.vo.AddedComponentEventVO;
	import me.feng.component.event.vo.RemovedComponentEventVO;
	import me.feng3d.fagalRE.FagalIdCenter;
	import me.feng3d.core.base.subgeometry.SubGeometry;

	/**
	 * 顶点动画 子网格
	 * @author feng 2014-8-28
	 */
	public class VertexSubGeometry extends Component
	{
		private var subGeometry:SubGeometry;

		public function VertexSubGeometry()
		{
			super();

			addEventListener(ComponentEvent.BE_ADDED_COMPONET, onBeAddedComponet);
			addEventListener(ComponentEvent.BE_REMOVED_COMPONET, onBeRemovedComponet);
		}

		/**
		 * 处理被添加事件
		 * @param event
		 */
		protected function onBeAddedComponet(event:ComponentEvent):void
		{
			var addedComponentEventVO:AddedComponentEventVO = event.data;
			subGeometry = addedComponentEventVO.container as SubGeometry;

			subGeometry.mapVABuffer(_.position0_va_3, 3);
			subGeometry.mapVABuffer(_.position1_va_3, 3);

			updateVertexData0(subGeometry.vertexPositionData.concat());
			updateVertexData1(subGeometry.vertexPositionData.concat());
		}

		/**
		 * 处理被移除事件
		 * @param event
		 */
		protected function onBeRemovedComponet(event:ComponentEvent):void
		{
			var removedComponentEventVO:RemovedComponentEventVO = event.data;
			subGeometry = null;
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

		/**
		 * Fagal编号中心
		 */
		public function get _():FagalIdCenter
		{
			return FagalIdCenter.instance;
		}
	}
}

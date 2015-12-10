package me.feng3d.components.subgeometry
{
	import me.feng.component.Component;
	import me.feng.component.event.ComponentEvent;
	import me.feng.component.event.vo.AddedComponentEventVO;
	import me.feng.component.event.vo.RemovedComponentEventVO;
	import me.feng3d.core.base.subgeometry.SubGeometry;

	/**
	 * 子几何体形变组件
	 * @author feng 2015-12-10
	 */
	public class SubGeometryTransformation extends Component
	{
		private var subGeometry:SubGeometry;

		public function SubGeometryTransformation()
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

	}
}

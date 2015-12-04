package me.feng.component
{
	import flash.display.DisplayObjectContainer;

	import me.feng.component.event.ComponentEvent;
	import me.feng.component.event.vo.AddedComponentEventVO;
	import me.feng.component.event.vo.RemovedComponentEventVO;
	import me.feng.debug.assert;

	/**
	 * 唯一名称组件
	 * @author warden_feng 2015-12-2
	 */
	public class UniqueNameComponent extends Component
	{

		public function UniqueNameComponent()
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
			assert(addedComponentEventVO.child == this);
			addedComponentEventVO.container.addEventListener(ComponentEvent.ADDED_COMPONET, onAddComponetContainer);
		}

		/**
		 * 处理被移除事件
		 * @param event
		 */
		protected function onBeRemovedComponet(event:ComponentEvent):void
		{
			var removedComponentEventVO:RemovedComponentEventVO = event.data;
			assert(removedComponentEventVO.child == this);
			removedComponentEventVO.container.removeEventListener(ComponentEvent.ADDED_COMPONET, onAddComponetContainer);
		}

		protected function onAddComponetContainer(event:ComponentEvent):void
		{
			var addedComponentEventVO:AddedComponentEventVO = event.data;

			checkUniqueName(addedComponentEventVO.container);
		}

		private function checkUniqueName(container:ComponentContainer):void
		{
			container

			new DisplayObjectContainer().numChildren;
		}

	}
}

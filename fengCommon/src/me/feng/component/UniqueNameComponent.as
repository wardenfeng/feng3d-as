package me.feng.component
{
	import flash.utils.Dictionary;

	import me.feng.component.event.ComponentEvent;
	import me.feng.component.event.vo.AddedComponentEventVO;
	import me.feng.component.event.vo.RemovedComponentEventVO;
	import me.feng.debug.assert;

	/**
	 * 唯一名称组件
	 * @author feng 2015-12-2
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
			addedComponentEventVO.container.addEventListener(ComponentEvent.ADDED_COMPONET, onAddedComponetContainer);
			checkUniqueName(addedComponentEventVO.container);
		}

		/**
		 * 处理被移除事件
		 * @param event
		 */
		protected function onBeRemovedComponet(event:ComponentEvent):void
		{
			var removedComponentEventVO:RemovedComponentEventVO = event.data;
			assert(removedComponentEventVO.child == this);
			removedComponentEventVO.container.removeEventListener(ComponentEvent.ADDED_COMPONET, onAddedComponetContainer);
		}

		/**
		 * 处理添加组件事件
		 * @param event
		 */
		protected function onAddedComponetContainer(event:ComponentEvent):void
		{
			var addedComponentEventVO:AddedComponentEventVO = event.data;

			checkUniqueName(addedComponentEventVO.container);
		}

		/**
		 * 检查子组件中名称是否唯一
		 * @param container
		 */
		private function checkUniqueName(container:Component):void
		{
			var nameDic:Dictionary = new Dictionary();
			for (var i:int = 0; i < container.numComponents; i++)
			{
				var component:Component = container.getComponentAt(i);
				if (nameDic[component.componentName])
				{
					throwEvent(new Error("存在多个子组件拥有相同的名称"));
				}
				nameDic[component.componentName] = true;
			}
		}
	}
}

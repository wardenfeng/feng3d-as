package me.feng3d.containers
{
	import me.feng.component.Component;
	import me.feng.component.event.ComponentEvent;
	import me.feng.component.event.vo.AddedComponentEventVO;
	import me.feng3d.events.Transform3DEvent;
	import me.feng3d.core.base.data.Transform3D;

	/**
	 * 3d容器变换组件
	 * @author feng 2016-3-9
	 */
	public class ContainerTransform3D extends Component
	{
		private var objectContainer3D:Container3D;

		/**
		 * 创建一个3d容器变换组件
		 */
		public function ContainerTransform3D()
		{
			addEventListener(ComponentEvent.BE_ADDED_COMPONET, onBeAddedComponet);
		}

		/**
		 * 处理组件被添加事件
		 * @param event
		 */
		protected function onBeAddedComponet(event:ComponentEvent):void
		{
			var data:AddedComponentEventVO = event.data;
			objectContainer3D = data.container as Container3D;
			objectContainer3D.transform3D.addEventListener(Transform3DEvent.TRANSFORM_CHANGED, onContainer3DTranformChange);
		}

		/**
		 * 处理容器变换事件
		 * @param event
		 */
		protected function onContainer3DTranformChange(event:Transform3DEvent):void
		{
			var len:uint = objectContainer3D.numChildren;
			for (var i:int = 0; i < len; i++)
			{
				var transform3D:Transform3D = objectContainer3D.getChildAt(i).transform3D;
				transform3D.invalidateTransform();
			}
		}
	}
}

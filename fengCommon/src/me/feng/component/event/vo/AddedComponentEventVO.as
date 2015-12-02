package me.feng.component.event.vo
{
	import me.feng.component.Component;
	import me.feng.component.ComponentContainer;

	/**
	 * 添加组件事件数据
	 * @author warden_feng 2015-12-2
	 */
	public class AddedComponentEventVO
	{
		public var container:ComponentContainer;
		public var child:Component;

		/**
		 * 添加组件事件数据
		 * @param container			组件容器
		 * @param child				子组件
		 */
		public function AddedComponentEventVO(container:ComponentContainer, child:Component)
		{
			this.container = container;
			this.child = child;
		}
	}
}

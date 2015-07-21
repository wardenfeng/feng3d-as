package me.feng.component
{
	import flash.events.Event;

	/**
	 * 组件容器（集合）
	 * @author warden_feng 2015-5-6
	 */
	public class ComponentContainer extends Component
	{
		/**
		 * 组件列表
		 */
		protected var components:Vector.<Component>;

		/**
		 * 创建一个组件容器
		 */
		public function ComponentContainer()
		{
			components = new Vector.<Component>();
		}

		/**
		 * 添加组件
		 * @param com 被添加组件
		 */
		public function addComponent(com:Component):void
		{
			if (indexOf(com) == -1)
			{
				components.push(com);
			}
		}

		/**
		 * 根据组件名称获取组件
		 * @param componentName		组件名称
		 * @return 					获取到的组件
		 */
		public function getComponent(componentName:String):*
		{
			for each (var com:Component in components)
			{
				if (com.componentName == componentName)
				{
					return com;
				}
			}
			return null;
		}

		/**
		 * 移除组件
		 * @param com 被移除组件
		 */
		public function removeComponent(com:Component):void
		{
			var index:int = indexOf(com);
			if (index != -1)
			{
				components.splice(index, 1);
			}
		}

		/**
		 * 使用 strict equality (===) 运算符搜索数组中的项，并返回项的索引位置。
		 * @param com	查找的组件
		 * @return		数组项的索引位置（从 0 开始）。如果未找到 searchElement 参数，则返回值为 -1。
		 */
		public function indexOf(com:Component):int
		{
			var index:int = components.indexOf(com);
			return index;
		}

		/**
		 * 判断是否拥有组件
		 * @param com	被检测的组件
		 * @return		true：拥有该组件；false：不拥有该组件。
		 */
		public function hasComponent(com:Component):Boolean
		{
			return indexOf(com) != -1;
		}

		/**
		 * 组件容器派发事件，该事件会转发给容器内所有组件
		 * @param event		派发的事件
		 * @return			如果成功调度了事件，则值为 true。值 false 表示失败或对事件调用了 preventDefault()。
		 */
		override public function dispatchEvent(event:Event):Boolean
		{
			//派发事件给所有组件
			for each (var com:Component in components)
			{
				com.dispatchEvent(event);
			}
			return super.dispatchEvent(event);
		}
	}
}

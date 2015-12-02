package me.feng.component
{
	import flash.events.Event;

	import me.feng.component.event.ComponentEvent;
	import me.feng.component.event.vo.AddedComponentEventVO;
	import me.feng.events.FEvent;

	/**
	 * 添加子组件后触发
	 */
	[Event(name = "addedComponet", type = "me.feng.component.event.ComponentEvent")]

	/**
	 * 移除子组件后触发
	 */
	[Event(name = "removedComponet", type = "me.feng.component.event.ComponentEvent")]

	/**
	 * 组件容器（集合）
	 * @author feng 2015-5-6
	 */
	public class ComponentContainer extends Component
	{
		/**
		 * 组件列表
		 */
		protected const children:Array = []; //我并不喜欢使用vector，这使得我不得不去处理越界的问题，繁琐！此处重新修改为Array！

		/**
		 * 创建一个组件容器
		 */
		public function ComponentContainer()
		{
			super();
		}

		/**
		 * 添加组件
		 * @param com 被添加组件
		 */
		public function addComponent(com:Component):void
		{
			if (indexOf(com) == -1)
			{
				children.push(com);
			}
			dispatchChildrenEvent(new ComponentEvent(ComponentEvent.ADDED_COMPONET, new AddedComponentEventVO(this, com)));
		}

		/**
		 * 根据组件名称获取组件
		 * @param componentName		组件名称
		 * @return 					获取到的组件
		 */
		public function getComponent(componentName:String):*
		{
			for each (var com:Component in children)
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
				children.splice(index, 1);
			}
		}

		/**
		 * 使用 strict equality (===) 运算符搜索数组中的项，并返回项的索引位置。
		 * @param com	查找的组件
		 * @return		数组项的索引位置（从 0 开始）。如果未找到 searchElement 参数，则返回值为 -1。
		 */
		public function indexOf(com:Component):int
		{
			var index:int = children.indexOf(com);
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
		 * 根据类定义获取组件
		 * @param cls
		 * @return
		 */
		public function getComponentByClass(cls:Class):*
		{
			var component:Component = findComponentByClass(cls)[0];

			if (component == null)
			{
				component = new cls();
				addComponent(component);
			}

			return component;
		}

		/**
		 * 根据类定义查找组件
		 * @param cls		类定义
		 * @return			返回与给出类定义一致的组件
		 */
		private function findComponentByClass(cls:Class):Array
		{
			var filterResult:Array = children.filter(function(item:Component, ... args):Boolean
			{
				return item is cls;
			});

			return filterResult;
		}

		/**
		 * 派发子组件事件
		 * <p>事件广播给子组件</p>
		 * @param event
		 */
		private function dispatchChildrenEvent(event:FEvent):void
		{
			children.forEach(function(item:Component, ... args):void
			{
				item.dispatchEvent(event);
			});
		}

		/**
		 * 组件容器派发事件，该事件会转发给容器内所有组件
		 * @param event		派发的事件
		 * @return			如果成功调度了事件，则值为 true。值 false 表示失败或对事件调用了 preventDefault()。
		 */
		override public function dispatchEvent(event:Event):Boolean
		{
			//派发事件给所有组件
			for each (var com:Component in children)
			{
				com.dispatchEvent(event);
			}
			return super.dispatchEvent(event);
		}
	}
}



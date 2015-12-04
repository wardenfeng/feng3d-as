package me.feng.component
{
	import avmplus.getQualifiedClassName;

	import me.feng.component.event.ComponentEvent;
	import me.feng.component.event.vo.AddedComponentEventVO;
	import me.feng.debug.assert;
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
		protected const components:Array = []; //我并不喜欢使用vector，这使得我不得不去处理越界的问题，繁琐！此处重新修改为Array！

		/**
		 * 创建一个组件容器
		 */
		public function ComponentContainer()
		{
			super();
		}

		/**
		 * 子组件个数
		 */
		public function get numComponents():int
		{
			return components.length;
		}

		/**
		 * 添加组件
		 * @param com 被添加组件
		 */
		public function addComponent(com:Component):void
		{
			assert(com != this, "子项与父项不能相同");

			if (hasComponent(com))
			{
				setComponentIndex(com, components.length - 1);
				return;
			}

			addComponentAt(com, components.length);
		}

		/**
		 * 添加组件到指定位置
		 * @param com			被添加的组件
		 * @param index			插入的位置
		 */
		public function addComponentAt(com:Component, index:int):void
		{
			assert(com != this, "子项与父项不能相同");
			assert(index >= 0 && index <= numComponents, "给出索引超出范围");

			if (hasComponent(com))
			{
				index = Math.min(index, components.length - 1);
				setComponentIndex(com, index)
				return;
			}

			components.splice(index, 0, com);
			dispatchChildrenEvent(new ComponentEvent(ComponentEvent.ADDED_COMPONET, new AddedComponentEventVO(this, com)));
		}

		/**
		 * 移除组件
		 * @param com 被移除组件
		 */
		public function removeComponent(com:Component):void
		{
			assert(hasComponent(com), "只能移除在容器中的组件");

			var index:int = getComponentIndex(com);
			removeComponentAt(index);
		}

		/**
		 * 移除组件
		 * @param index		要删除的 Component 的子索引。
		 */
		public function removeComponentAt(index:int):Component
		{
			assert(index >= 0 && index < numComponents, "给出索引超出范围");

			var removeComponent:Component = components.splice(index, 1)[0];
			return removeComponent;
		}

		/**
		 * 获取组件在容器的索引位置
		 * @param com			查询的组件
		 * @return				组件在容器的索引位置
		 */
		public function getComponentIndex(com:Component):int
		{
			assert(components.indexOf(com) != -1, "组件不在容器中");

			var index:int = components.indexOf(com);
			return index;
		}

		/**
		 * 设置子组件的位置
		 * @param com				子组件
		 * @param index				位置索引
		 */
		public function setComponentIndex(com:Component, index:uint):void
		{
			assert(index >= 0 && index < numComponents, "给出索引超出范围");

			var oldIndex:int = components.indexOf(com);
			assert(oldIndex >= 0 && oldIndex < numComponents, "子组件不在容器内");

			components.splice(oldIndex, 1);
			components.splice(index, 0, com);
		}

		/**
		 * 根据组件名称获取组件
		 * @param componentName		组件名称
		 * @return 					获取到的组件
		 */
		public function getComponentByName(componentName:String):*
		{
			var filterResult:Array = getComponentsByName(componentName);
			return filterResult[0];
		}

		/**
		 * 获取与给出名称相同的所有组件
		 * @param componentName		组件名称
		 * @return 					获取到的组件
		 */
		public function getComponentsByName(componentName:String):Array
		{
			var filterResult:Array = components.filter(function(item:Component, ... args):Boolean
			{
				return item.name == componentName;
			});

			return filterResult;
		}

		/**
		 * 根据类定义获取组件
		 * <p>如果存在多个则返回第一个</p>
		 * @param cls				类定义
		 * @return
		 */
		public function getComponentByClass(cls:Class):*
		{
			var component:Component = getComponentsByClass(cls)[0];

			return component;
		}

		/**
		 * 根据类定义查找组件
		 * @param cls		类定义
		 * @return			返回与给出类定义一致的组件
		 */
		public function getComponentsByClass(cls:Class):Array
		{
			var filterResult:Array = components.filter(function(item:Component, ... args):Boolean
			{
				var className1:String = getQualifiedClassName(item);
				var className2:String = getQualifiedClassName(cls);
				return className1 == className2;
			});

			return filterResult;
		}

		/**
		 * 根据类定义获取或创建组件
		 * <p>当不存在该类型对象时创建一个该组件并且添加到容器中</p>
		 * @param cls
		 * @return
		 */
		public function getOrCreateComponentByClass(cls:Class):*
		{
			var component:Component = getComponentByClass(cls);

			if (component == null)
			{
				component = new cls();
				addComponent(component);
			}

			return component;
		}

		/**
		 * 判断是否拥有组件
		 * @param com	被检测的组件
		 * @return		true：拥有该组件；false：不拥有该组件。
		 */
		public function hasComponent(com:Component):Boolean
		{
			return components.indexOf(com) != -1;
		}

		/**
		 * 交换子组件位置
		 * @param index1		第一个子组件的索引位置
		 * @param index2		第二个子组件的索引位置
		 */
		public function swapComponentsAt(index1:int, index2:int):void
		{
			assert(index1 >= 0 && index1 < numComponents, "第一个子组件的索引位置超出范围");
			assert(index2 >= 0 && index2 < numComponents, "第二个子组件的索引位置超出范围");

			var temp:Component = components[index1];
			components[index1] = components[index2];
			components[index2] = temp;
		}

		/**
		 * 交换子组件位置
		 * @param com1		第一个子组件
		 * @param com2		第二个子组件
		 */
		public function swapComponents(com1:Component, com2:Component):void
		{
			assert(hasComponent(com1), "第一个子组件不在容器中");
			assert(hasComponent(com2), "第二个子组件不在容器中");

			swapComponentsAt(getComponentIndex(com1), getComponentIndex(com2));
		}

		/**
		 * 派发子组件事件
		 * <p>事件广播给子组件</p>
		 * @param event
		 */
		private function dispatchChildrenEvent(event:FEvent):void
		{
			components.forEach(function(item:Component, ... args):void
			{
				item.dispatchEvent(event);
			});
		}

	}
}

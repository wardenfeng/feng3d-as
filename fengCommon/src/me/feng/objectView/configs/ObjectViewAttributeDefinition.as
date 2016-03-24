package me.feng.objectView.configs
{
	import flash.utils.getQualifiedClassName;

	import me.feng.utils.ClassUtils;

	/**
	 * 对象界面属性定义
	 * @author feng 2016-3-23
	 */
	public class ObjectViewAttributeDefinition
	{
		/**
		 * 属性所在块名称
		 */
		public var block:String;
		/**
		 * 属性界面类定义
		 */
		public var view:Class;

		/**
		 * 是否空数据
		 */
		public function isEmpty():Boolean
		{
			if (block != null && block.length > 0)
				return false;

			if (view != null)
				return false;

			return true;
		}

		/**
		 * 转化为对象
		 */
		public function getObject():Object
		{
			var object:Object = {};
			if (block != null && block.length > 0)
				object.block = block;

			if (view != null)
				object.view = getQualifiedClassName(view);

			return object;
		}

		/**
		 * 设置数据
		 */
		public function setObject(object:Object):void
		{
			block = object.block;
			view = ClassUtils.getClass(object.view);
		}

		/**
		 * 清除数据
		 */
		public function clear():void
		{
			block = "";
			view = null;
		}
	}
}

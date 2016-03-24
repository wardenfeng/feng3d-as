package me.feng.objectView.configs
{
	import flash.utils.Dictionary;

	import avmplus.getQualifiedClassName;

	import me.feng.objectView.base.view.DefaultBaseObjectView;
	import me.feng.objectView.base.view.DefaultObjectAttributeView;
	import me.feng.objectView.block.view.DefaultObjectAttributeBlockView;
	import me.feng.objectView.block.view.DefaultObjectViewWithBlock;
	import me.feng.utils.ClassUtils;

	/**
	 * ObjectView总配置数据
	 * @author feng 2016-3-23
	 */
	public class ObjectViewConfigVO
	{
		/**
		 * 默认基础类型对象界面类定义
		 */
		public var baseObjectViewClass:Class = DefaultBaseObjectView;

		/**
		 * 默认对象界面类定义
		 */
		//		public static var DefaultObjectViewClass:Class = DefaultObjectView;
		public var objectViewClass:Class = DefaultObjectViewWithBlock;

		/**
		 * 默认对象属性界面类定义
		 */
		public var objectAttributeViewClass:Class = DefaultObjectAttributeView;

		/**
		 * 属性块默认界面
		 */
		public var objectAttributeBlockView:Class = DefaultObjectAttributeBlockView;

		/**
		 * 指定属性类型界面类定义字典（key:属性类名称,value:属性界面类定义）
		 */
		private var attributeDefaultViewClassDic:Dictionary = new Dictionary();

		/**
		 * ObjectView类配置字典 （key：类名称，value：ObjectView类配置）
		 */
		private var classConfigDic:Dictionary = new Dictionary();

		/**
		 * 获取ObjectView类配置
		 * @param objectClass			对象类定义
		 * @return
		 */
		public function getClassConfig(object:Object):ObjectViewClassConfig
		{
			var objectClass:Class = ClassUtils.getClass(object);
			if (objectClass == null)
			{
				return null;
			}
			var className:String = getQualifiedClassName(objectClass);

			if (classConfigDic[className] == null)
			{
				classConfigDic[className] = new ObjectViewClassConfig();
			}
			return classConfigDic[className];
		}

		/**
		 * 获取特定类型的默认属性界面类定义
		 * @param type				类型
		 * @return
		 */
		public function getAttributeDefaultViewClass(type:String):Class
		{
			return attributeDefaultViewClassDic[type];
		}

		/**
		 * 设置特定类型的默认属性界面类定义
		 * @param attributeClass			特定类型
		 * @param viewClass					属性界面类定义
		 */
		public function setAttributeDefaultViewClass(attributeClass:Object, viewClass:Object):void
		{
			var attributeCls:Class = ClassUtils.getClass(attributeClass);
			if (attributeCls == null)
			{
				return;
			}
			var attributeClassName:String = getQualifiedClassName(attributeCls);

			var cls:Class = ClassUtils.getClass(viewClass);
			attributeDefaultViewClassDic[attributeClassName] = cls;
		}
	}
}

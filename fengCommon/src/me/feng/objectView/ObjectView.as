package me.feng.objectView
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	import avmplus.getQualifiedClassName;

	import me.feng.utils.ClassUtils;

	/**
	 * 对象界面
	 * @author feng 2016-3-10
	 */
	public class ObjectView
	{
		/**
		 * 默认基础类型对象界面类定义
		 */
		public static var DefaultBaseObjectViewClass:Class = DefaultBaseObjectView;

		/**
		 * 默认对象界面类定义
		 */
		public static var DefaultObjectViewClass:Class = DefaultObjectView;

		/**
		 * 自定义对象界面类定义字典（key:自定义类名称,value:界面类定义）
		 */
		private static var customObjectViewClassDic:Dictionary = new Dictionary();

		/**
		 * 自定义对象属性界面类定义字典（key:类名称+属性名,value:属性界面类定义）
		 */
		private static var customObjectAttributeViewClassDic:Dictionary = new Dictionary();

		/**
		 * 获取对象界面
		 * @param object	用于生成界面的对象
		 */
		public static function getObjectView(object:Object):DisplayObject
		{
			var viewClass:Class = getObjectViewClass(object);
			var view:DisplayObject = new viewClass();
			IObjectView(view).data = object;
			return view;
		}

		/**
		 * 获取对象属性界面
		 * @param objectAttributeInfo		对象属性信息
		 * @return							对象属性界面
		 */
		public static function getObjectAttributeView(objectAttributeInfo:ObjectAttributeInfo):DisplayObject
		{
			var viewClass:Class = getObjectAttributeViewClass(objectAttributeInfo);
			var view:DisplayObject = new viewClass();
			IObjectAttributeView(view).objectAttributeInfo = objectAttributeInfo;
			return view;
		}

		/**
		 * 设置自定义对象界面类定义
		 * @param object				指定对象类型
		 * @param viewClass				自定义对象界面类定义（该类必须是实现IObjectView接口并且是DisplayObject的子类）
		 */
		public static function setCustomObjectViewClass(object:Object, viewClass:Class):void
		{
			var className:String = getQualifiedClassName(object);
			customObjectViewClassDic[className] = viewClass;
		}

		/**
		 * 设置自定义对象属性界面类定义
		 * @param owner					属性拥有者
		 * @param attributeName			属性名称
		 * @param viewClass				自定义对象属性界面类定义（该类必须是实现IObjectAttributeView接口并且是DisplayObject的子类）
		 */
		public static function setCustomObjectAttributeViewClass(owner:Object, attributeName:String, viewClass:Class):void
		{
			var key:String = getClassAttributeID(owner, attributeName);
			customObjectAttributeViewClassDic[key] = viewClass;
		}

		/**
		 * 获取对象界面类定义
		 * @param object		用于生成界面的对象
		 * @return				对象界面类定义
		 */
		private static function getObjectViewClass(object:Object):Class
		{
			//获取自定义类型界面类定义
			var viewClass:Class = getCustomObjectViewClass(object);
			if (viewClass != null)
				return viewClass;

			//返回基础类型界面类定义
			var isBaseType:Boolean = ClassUtils.isBaseType(object);
			if (isBaseType)
				return DefaultBaseObjectViewClass;

			//返回默认类型界面类定义
			return DefaultObjectViewClass;
		}

		/**
		 * 获取自定义对象界面类
		 * @param object		用于生成界面的对象
		 * @return 				自定义对象界面类定义
		 */
		private static function getCustomObjectViewClass(object:Object):Class
		{
			var className:String = getQualifiedClassName(object);
			var viewClass:Class = customObjectViewClassDic[className];
			return viewClass;
		}

		/**
		 * 获取对象属性界面类定义
		 * @param objectAttributeInfo		对象属性信息
		 * @return							对象属性界面类定义
		 */
		private static function getObjectAttributeViewClass(objectAttributeInfo:ObjectAttributeInfo):Class
		{
			//获取自定义对象属性界面类定义
			var viewClass:Class = getCustomObjectAttributeViewClass(objectAttributeInfo.owner, objectAttributeInfo.name);
			if (viewClass != null)
				return viewClass;

			//返回默认对象属性界面类定义
			return DefaultObjectAttributeView;
		}

		/**
		 * 获取自定义对象属性界面类定义
		 * @param owner					属性拥有者
		 * @param attributeName			属性名称
		 * @return						自定义对象属性界面类定义
		 */
		private static function getCustomObjectAttributeViewClass(owner:Object, attributeName:String):Class
		{
			var key:String = getClassAttributeID(owner, attributeName);
			var viewClass:Class = customObjectAttributeViewClassDic[key];
			return viewClass;
		}

		/**
		 * 获取类属性ID
		 * @param owner					属性拥有者
		 * @param attributeName			属性名称
		 * @return						类属性ID
		 */
		public static function getClassAttributeID(owner:Object, attributeName:String):String
		{
			var className:String = getQualifiedClassName(owner);
			var key:String = className + "-" + attributeName;
			return key;
		}
	}
}



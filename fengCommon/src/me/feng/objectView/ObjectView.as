package me.feng.objectView
{
	import flash.display.DisplayObject;

	import avmplus.getQualifiedClassName;

	import me.feng.objectView.base.data.ObjectAttributeInfo;
	import me.feng.objectView.base.utils.ObjectAttributeUtils;
	import me.feng.objectView.base.utils.ObjectViewUtils;

	/**
	 * 对象界面
	 * @author feng 2016-3-10
	 */
	public class ObjectView
	{
		/**
		 * ObjectView配置
		 */
		private static var objectViewConfig:ObjectViewConfig = new ObjectViewConfig();
		private static var objectViewUtils:ObjectViewUtils = new ObjectViewUtils();
		private static var objectAttributeUtils:ObjectAttributeUtils = new ObjectAttributeUtils();

		/**
		 * 获取对象界面
		 * @param object	用于生成界面的对象
		 */
		public static function getObjectView(object:Object):DisplayObject
		{
			var view:DisplayObject = objectViewUtils.getObjectView(object);
			return view;
		}

		/**
		 * 获取对象属性界面
		 * @param objectAttributeInfo		对象属性信息
		 * @return							对象属性界面
		 */
		public static function getObjectAttributeView(objectAttributeInfo:ObjectAttributeInfo):DisplayObject
		{
			var view:DisplayObject = objectAttributeUtils.getObjectAttributeView(objectAttributeInfo);
			return view;
		}

		/**
		 * 设置自定义对象界面类定义
		 * @param object				指定对象类型
		 * @param viewClass				自定义对象界面类定义（该类必须是实现IObjectView接口并且是DisplayObject的子类）
		 */
		public static function setCustomObjectViewClass(object:Object, viewClass:Class):void
		{
			objectViewUtils.setCustomObjectViewClass(object, viewClass);
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
			objectAttributeUtils.customObjectAttributeViewClassDic[key] = viewClass;
		}

		/**
		 * 设置所有特定类型属性的界面类定义
		 * @param attributeClass			特定属性类型
		 * @param viewClass					属性界面类
		 */
		public static function setAttributeViewClassByType(attributeClass:Class, viewClass:Class):void
		{
			var attributeClassName:String = getQualifiedClassName(attributeClass);
			objectAttributeUtils.attributeViewClassByType[attributeClassName] = viewClass;
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

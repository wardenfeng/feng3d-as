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
		internal static var objectViewUtils:ObjectViewUtils = new ObjectViewUtils();
		internal static var objectAttributeUtils:ObjectAttributeUtils = new ObjectAttributeUtils();

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

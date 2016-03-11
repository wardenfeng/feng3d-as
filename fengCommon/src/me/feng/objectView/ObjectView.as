package me.feng.objectView
{
	import com.bit101.components.VBox;

	import flash.display.DisplayObject;
	import flash.text.TextField;
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
		 * 自定义对象界面类定义字典（key:自定义类型,value:界面类定义）
		 */
		public static var customObjectViewClassDic:Dictionary = new Dictionary();

		/**
		 * 获取对象界面
		 * @param object	用于生成界面的对象
		 */
		public static function getObjectView(object:Object):DisplayObject
		{
			var objectView:DisplayObject = getCustomObjectView(object);
			if (objectView != null)
				return objectView;

			objectView = getDefaultObjectView(object);
			return objectView;
		}

		/**
		 * 获取默认对象界面
		 * @param object	用于生成界面的对象
		 * @return			对象界面
		 *
		 */
		public static function getDefaultObjectView(object:Object):DisplayObject
		{
			var objectView:DisplayObject;
			var isBaseType:Boolean = ClassUtils.isBaseType(object);
			if (isBaseType)
			{
				objectView = getBaseTypeView(object);
				return objectView;
			}

			var objectAttributeInfos:Vector.<ObjectAttributeInfo> = ObjectAttributeInfo.getObjectAttributeInfos(object);
			var vBox:VBox = new VBox;
			for (var i:int = 0; i < objectAttributeInfos.length; i++)
			{
				var displayObject:DisplayObject = getObjectAttributeView(objectAttributeInfos[i]);
				vBox.addChild(displayObject);
			}
			return vBox;
		}

		/**
		 * 获取对象属性界面
		 * @param objectAttributeInfo		对象属性信息
		 * @return							对象属性界面
		 */
		private static function getObjectAttributeView(objectAttributeInfo:ObjectAttributeInfo):DisplayObject
		{
			var objectAttributeView:DefaultObjectAttributeView = new DefaultObjectAttributeView();
			objectAttributeView.objectAttributeInfo = objectAttributeInfo;
			return objectAttributeView;
		}

		/**
		 * 获取自定义对象界面
		 * @param object		用于生成界面的对象
		 * @return				对象界面
		 */
		private static function getCustomObjectView(object:Object):DisplayObject
		{
			var className:String = getQualifiedClassName(object);
			var viewClass:Class = customObjectViewClassDic[className];

			if (viewClass == null)
				return null;

			var view:DisplayObject = new viewClass();
			//			view.data = object;
			return view;
		}

		/**
		 * 获取基础类型界面
		 * @param object	基础类型对象
		 * @return			对象界面
		 */
		private static function getBaseTypeView(object:Object):DisplayObject
		{
			var objectView:DisplayObject = getCustomObjectView(object);
			if (objectView != null)
				return objectView;

			var textField:TextField = new TextField();
			textField.text = String(object);
			return textField;
		}
	}
}

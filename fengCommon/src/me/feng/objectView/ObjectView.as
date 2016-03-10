package me.feng.objectView
{
	import com.Tevoydes.objectView.ObjectAttributeGroup;
	import com.bit101.components.VBox;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	import avmplus.describeTypeInstance;
	import avmplus.getQualifiedClassName;

	import me.feng.debug.assert;
	import me.feng.utils.ClassUtils;

	/**
	 * 对象界面
	 * @author feng 2016-3-10
	 */
	public class ObjectView
	{
		/**
		 * 自定义类型对象界面类定义字典（key:自定义类型,value:界面类定义）
		 */
		public static var customTypeObjectViewClassDic:Dictionary = new Dictionary();

		/**类对应Json结构的字典 */
		private static var classToJsonDic:Dictionary = new Dictionary();

		/**
		 * 获取对象界面
		 * @param object	用于生成界面的对象
		 */
		public static function getObjectView(object:Object):DisplayObject
		{
			assert(object != null);

			var objectView:DisplayObject = getObjectViewByCustomType(object);
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


			var textField:TextField = new TextField();
			textField.text = object.toString();
			return textField;
		}

		/**
		 * 获取自定义对象界面
		 * @param object		用于生成界面的对象
		 * @return				对象界面
		 */
		private static function getObjectViewByCustomType(object:Object):DisplayObject
		{
			assert(object != null);

			var className:String = getQualifiedClassName(object);
			var viewClass:Class = customTypeObjectViewClassDic[className];

			if (viewClass == null)
				return null;

			var view:DisplayObject = new viewClass();
			//			view.data = object;
			return view;
		}

		private static function getBaseTypeView(object:Object):DisplayObject
		{
			var objectView:DisplayObject = getObjectViewByCustomType(object);
			if (objectView != null)
				return objectView;

			var textField:TextField = new TextField();
			textField.text = object.toString();
			return textField;
		}

		/**
		 *创建结构
		 *
		 */
		private static function createStruct(object:Object):Vector.<ObjectAttributeGroup>
		{
			/**模型组数组 */
			var objectAttrGroupVec:Vector.<ObjectAttributeGroup> = new Vector.<ObjectAttributeGroup>;
			for (var str:String in object)
			{
				var tempGroup:ObjectAttributeGroup = new ObjectAttributeGroup;
				tempGroup.create(object[str], str);
				objectAttrGroupVec.push(tempGroup);
			}

			//var str:String = getQualifiedClassName(object);

			return objectAttrGroupVec;
		}

		/**
		 *添加数据到界面
		 *
		 */
		public static function addDataToView(object:Object, container:DisplayObjectContainer):void
		{

			var str:String = getQualifiedClassName(object);
			/**模型组数组 */
			var objectAttrGroupVec:Vector.<ObjectAttributeGroup> = createStruct(object);

			var vBox:VBox = new VBox;
			for (var i:int = 0; i < objectAttrGroupVec.length; i++)
			{
				var tempVBox:VBox = objectAttrGroupVec[i].getGroupData(object);
				vBox.addChildAt(tempVBox, vBox.numChildren);
			}
			vBox.x = 0;
			vBox.y = 20;
			container.addChild(vBox);
		}
	}
}

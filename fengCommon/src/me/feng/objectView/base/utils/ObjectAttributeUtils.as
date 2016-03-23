package me.feng.objectView.base.utils
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	import avmplus.describeTypeInstance;
	import avmplus.getQualifiedClassName;

	import me.feng.objectView.ObjectView;
	import me.feng.objectView.base.IObjectAttributeView;
	import me.feng.objectView.base.data.ObjectAttributeInfo;
	import me.feng.objectView.base.view.DefaultObjectAttributeView;
	import me.feng.utils.ClassUtils;

	/**
	 * 对象属性工具
	 * @author feng 2016-3-22
	 */
	public class ObjectAttributeUtils
	{
		/**
		 * 默认对象属性界面类定义
		 */
		public var objectAttributeViewClass:Class = DefaultObjectAttributeView;

		/**
		 * 自定义对象属性界面类定义字典（key:类名称+属性名,value:属性界面类定义）
		 */
		public var customObjectAttributeViewClassDic:Dictionary = new Dictionary();

		/**
		 * 指定属性类型界面类定义字典（key:属性类名称,value:属性界面类定义）
		 */
		public var attributeViewClassByType:Dictionary = new Dictionary();

		/**
		 * 实例所有固定实例属性字典 （key:实例类名,value:实例所有固定实例属性）
		 */
		private static var objectFixedAttributeInfoListDic:Dictionary = new Dictionary();

		/**
		 * 实例固定实例属性字典 （key:固定实例属性ID,value:实例固定实例属性）
		 */
		private static var objectFixedAttributeInfoDic:Dictionary = new Dictionary();

		/**
		 * 获取对象属性界面
		 * @param objectAttributeInfo		对象属性信息
		 * @return							对象属性界面
		 */
		public function getObjectAttributeView(objectAttributeInfo:ObjectAttributeInfo):DisplayObject
		{
			var viewClass:Class = getObjectAttributeViewClass(objectAttributeInfo);
			var view:DisplayObject = new viewClass();
			IObjectAttributeView(view).objectAttributeInfo = objectAttributeInfo;
			return view;
		}

		/**
		 * 获取对象属性界面类定义
		 * @param objectAttributeInfo		对象属性信息
		 * @return							对象属性界面类定义
		 */
		private function getObjectAttributeViewClass(objectAttributeInfo:ObjectAttributeInfo):Class
		{
			//获取自定义对象属性界面类定义
			var viewClass:Class = getCustomObjectAttributeViewClass(objectAttributeInfo.owner, objectAttributeInfo.name);
			if (viewClass != null)
				return viewClass;

			viewClass = attributeViewClassByType[objectAttributeInfo.type];
			if (viewClass != null)
				return viewClass;

			//返回默认对象属性界面类定义
			return objectAttributeViewClass;
		}

		/**
		 * 获取自定义对象属性界面类定义
		 * @param owner					属性拥有者
		 * @param attributeName			属性名称
		 * @return						自定义对象属性界面类定义
		 */
		private function getCustomObjectAttributeViewClass(owner:Object, attributeName:String):Class
		{
			var key:String = ObjectView.getClassAttributeID(owner, attributeName);
			var viewClass:Class = customObjectAttributeViewClassDic[key];
			return viewClass;
		}

		/**
		 * 获取对象属性信息
		 * @param object		指定对象
		 * @return				属性信息
		 */
		public static function getObjectAttributeInfos(object:Object):Vector.<ObjectAttributeInfo>
		{
			var objectAttributeInfos:Vector.<ObjectAttributeInfo> = new Vector.<ObjectAttributeInfo>();

			var FixedAttributeInfos:Vector.<ObjectAttributeInfo> = getObjectFixedAttributeInfoList(object);
			objectAttributeInfos = objectAttributeInfos.concat(FixedAttributeInfos);

			var dynamicAttributeInfos:Vector.<ObjectAttributeInfo> = getObjectDynamicAttributeInfosList(object);
			objectAttributeInfos = objectAttributeInfos.concat(dynamicAttributeInfos);

			return objectAttributeInfos;
		}

		/**
		 * 获取实例属性信息
		 * @param object				指定对象
		 * @param attributeName			属性名称
		 * @return						实例属性信息
		 */
		public function getObjectAttributeInfo(object:Object, attributeName:String):ObjectAttributeInfo
		{
			if (!object.hasOwnProperty(attributeName))
				return null;

			var objectAttributeInfo:ObjectAttributeInfo = null;

			//固定实例属性
			var classAttributeID:String = ObjectView.getClassAttributeID(object, attributeName);
			objectAttributeInfo = objectFixedAttributeInfoDic[classAttributeID];
			if (objectAttributeInfo != null)
				return objectAttributeInfo;

			//动态属性
			objectAttributeInfo = getObjectDynamicAttributeInfo(object, attributeName);
			return objectAttributeInfo;
		}

		/**
		 * 获取对象所有动态属性信息
		 * @param object		指定对象
		 * @return 				属性信息
		 */
		public static function getObjectDynamicAttributeInfosList(object:Object):Vector.<ObjectAttributeInfo>
		{
			var objectAttributeInfos:Vector.<ObjectAttributeInfo> = new Vector.<ObjectAttributeInfo>();

			for (var key:String in object)
			{
				var objectAttributeInfo:ObjectAttributeInfo = getObjectDynamicAttributeInfo(object, key);
				objectAttributeInfos.push(objectAttributeInfo);
			}

			return objectAttributeInfos;
		}

		/**
		 * 获取对象动态属性信息
		 * @param object
		 * @param attributeName
		 * @return
		 */
		public static function getObjectDynamicAttributeInfo(object:Object, attributeName:String):ObjectAttributeInfo
		{
			var objectAttributeInfo:ObjectAttributeInfo = new ObjectAttributeInfo();
			objectAttributeInfo.name = attributeName;
			objectAttributeInfo.type = getQualifiedClassName(object[attributeName]);
			objectAttributeInfo.owner = object;
			return objectAttributeInfo;
		}

		/**
		 * 获取对象所有固定实例属性信息
		 * @param object		指定对象
		 * @return 				属性信息
		 */
		public static function getObjectFixedAttributeInfoList(object:Object):Vector.<ObjectAttributeInfo>
		{
			var className:String = getQualifiedClassName(object);

			if (objectFixedAttributeInfoListDic[className] != null)
				return objectFixedAttributeInfoListDic[className];

			var objectAttributeInfos:Vector.<ObjectAttributeInfo> = objectFixedAttributeInfoListDic[className] = new Vector.<ObjectAttributeInfo>();

			var cls:Class = ClassUtils.getClass(object);
			var describeInfo:Object = describeTypeInstance(cls);
			var Fixeds:Array = describeInfo.traits.Fixeds;
			for (var i:int = 0; Fixeds != null && i < Fixeds.length; i++)
			{
				var Fixed:Object = Fixeds[i];

				var objectAttributeInfo:ObjectAttributeInfo = new ObjectAttributeInfo();
				objectAttributeInfo.name = Fixed.name;
				objectAttributeInfo.type = Fixed.type;
				objectAttributeInfo.owner = object;
				objectAttributeInfos.push(objectAttributeInfo);

				var classAttributeID:String = ObjectView.getClassAttributeID(object, Fixed.name);
				objectFixedAttributeInfoDic[classAttributeID] = objectAttributeInfo;
			}

			return objectAttributeInfos;
		}
	}
}
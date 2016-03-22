package me.feng.objectView
{
	import flash.utils.Dictionary;

	import avmplus.describeTypeInstance;
	import avmplus.getQualifiedClassName;

	import me.feng.utils.ClassUtils;

	/**
	 * 对象属性信息
	 * @author feng 2016-3-10
	 */
	public class ObjectAttributeInfo
	{
		/**
		 * 属性名称
		 */
		public var name:String;
		/**
		 * 属性类型
		 */
		public var type:String;

		/**
		 * 属性拥有者
		 */
		public var owner:Object;

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
		public static function getObjectAttributeInfo(object:Object, attributeName:String):ObjectAttributeInfo
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
		private static function getObjectDynamicAttributeInfosList(object:Object):Vector.<ObjectAttributeInfo>
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
		private static function getObjectDynamicAttributeInfo(object:Object, attributeName:String):ObjectAttributeInfo
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
		private static function getObjectFixedAttributeInfoList(object:Object):Vector.<ObjectAttributeInfo>
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

		/**
		 * 实例所有固定实例属性字典 （key:实例类名,value:实例所有固定实例属性）
		 */
		private static var objectFixedAttributeInfoListDic:Dictionary = new Dictionary();

		/**
		 * 实例固定实例属性字典 （key:固定实例属性ID,value:实例固定实例属性）
		 */
		private static var objectFixedAttributeInfoDic:Dictionary = new Dictionary();
	}
}



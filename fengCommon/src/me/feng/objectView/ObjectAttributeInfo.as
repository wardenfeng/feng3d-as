package me.feng.objectView
{
	import flash.utils.getDefinitionByName;

	import avmplus.describeTypeInstance;
	import avmplus.getQualifiedClassName;

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

		public function ObjectAttributeInfo()
		{
		}

		/**
		 * 获取对象属性信息
		 * @param object		指定对象
		 * @return				属性信息
		 */
		public static function getObjectAttributeInfos(object:Object):Vector.<ObjectAttributeInfo>
		{
			var objectAttributeInfos:Vector.<ObjectAttributeInfo> = new Vector.<ObjectAttributeInfo>();

			var variableAttributeInfos:Vector.<ObjectAttributeInfo> = getObjectVariableAttributeInfos(object);
			objectAttributeInfos = objectAttributeInfos.concat(objectAttributeInfos);

			var dynamicAttributeInfos:Vector.<ObjectAttributeInfo> = getObjectDynamicAttributeInfos(object);
			objectAttributeInfos = objectAttributeInfos.concat(dynamicAttributeInfos);

			return objectAttributeInfos;
		}

		/**
		 * 获取对象动态属性信息
		 * @param object		指定对象
		 * @return 				属性信息
		 */
		private static function getObjectDynamicAttributeInfos(object:Object):Vector.<ObjectAttributeInfo>
		{
			var objectAttributeInfos:Vector.<ObjectAttributeInfo> = new Vector.<ObjectAttributeInfo>();

			for (var key:String in object)
			{
				var objectAttributeInfo:ObjectAttributeInfo = new ObjectAttributeInfo();
				objectAttributeInfo.name = key;
				objectAttributeInfo.type = getQualifiedClassName(object[key]);
				objectAttributeInfo.owner = object;
				objectAttributeInfos.push(objectAttributeInfo);
			}

			return objectAttributeInfos;
		}

		/**
		 * 获取对象普通属性信息
		 * @param object		指定对象
		 * @return 				属性信息
		 */
		private static function getObjectVariableAttributeInfos(object:Object):Vector.<ObjectAttributeInfo>
		{
			var objectAttributeInfos:Vector.<ObjectAttributeInfo> = new Vector.<ObjectAttributeInfo>();

			var cls:* = object;
			if (!(cls as Class))
				cls = getDefinitionByName(getQualifiedClassName(cls));
			var describeInfo:Object = describeTypeInstance(cls);
			var variables:Array = describeInfo.traits.variables;
			for (var i:int = 0; variables != null && i < variables.length; i++)
			{
				var variable:Object = variables[i];

				var objectAttributeInfo:ObjectAttributeInfo = new ObjectAttributeInfo();
				objectAttributeInfo.name = variable.name;
				objectAttributeInfo.type = variable.type;
				objectAttributeInfo.owner = object;
				objectAttributeInfos.push(objectAttributeInfo);
			}

			return objectAttributeInfos;
		}
	}
}

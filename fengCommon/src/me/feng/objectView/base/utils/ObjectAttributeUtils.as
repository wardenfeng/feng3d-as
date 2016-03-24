package me.feng.objectView.base.utils
{
	import flash.display.DisplayObject;

	import avmplus.describeTypeInstance;
	import avmplus.getQualifiedClassName;

	import me.feng.objectView.base.IObjectAttributeView;
	import me.feng.objectView.base.data.ObjectAttributeInfo;
	import me.feng.objectView.configs.ObjectViewClassConfig;
	import me.feng.objectView.configs.ObjectViewConfigVO;
	import me.feng.utils.ClassUtils;

	/**
	 * 对象属性工具
	 * @author feng 2016-3-22
	 */
	public class ObjectAttributeUtils
	{
		/**
		 * ObjectView总配置数据
		 */
		private var objectViewConfigVO:ObjectViewConfigVO;

		/**
		 * 构建
		 */
		public function ObjectAttributeUtils(objectViewConfigVO:ObjectViewConfigVO)
		{
			this.objectViewConfigVO = objectViewConfigVO;
		}

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

			viewClass = objectViewConfigVO.getAttributeDefaultViewClassByType(objectAttributeInfo.type);
			if (viewClass != null)
				return viewClass;

			//返回默认对象属性界面类定义
			return objectViewConfigVO.defaultObjectAttributeViewClass;
		}

		/**
		 * 获取自定义对象属性界面类定义
		 * @param owner					属性拥有者
		 * @param attributeName			属性名称
		 * @return						自定义对象属性界面类定义
		 */
		private function getCustomObjectAttributeViewClass(owner:Object, attributeName:String):Class
		{
			var objectViewClassConfig:ObjectViewClassConfig = objectViewConfigVO.getClassConfig(owner);
			var viewClass:Class = objectViewClassConfig.getAttributeDefinitionViewClass(attributeName);
			return viewClass;
		}

		/**
		 * 获取对象属性信息
		 * @param object		指定对象
		 * @return				属性信息
		 */
		public function getObjectAttributeInfos(object:Object):Vector.<ObjectAttributeInfo>
		{
			var objectAttributeInfos:Vector.<ObjectAttributeInfo> = new Vector.<ObjectAttributeInfo>();

			var FixedAttributeInfos:Vector.<ObjectAttributeInfo> = getObjectFixedAttributeInfoList(object);
			objectAttributeInfos = objectAttributeInfos.concat(FixedAttributeInfos);

			var dynamicAttributeInfos:Vector.<ObjectAttributeInfo> = getObjectDynamicAttributeInfosList(object);
			objectAttributeInfos = objectAttributeInfos.concat(dynamicAttributeInfos);

			return objectAttributeInfos;
		}

		/**
		 * 获取对象所有动态属性信息
		 * @param object		指定对象
		 * @return 				属性信息
		 */
		public function getObjectDynamicAttributeInfosList(object:Object):Vector.<ObjectAttributeInfo>
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
		public function getObjectDynamicAttributeInfo(object:Object, attributeName:String):ObjectAttributeInfo
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
		public function getObjectFixedAttributeInfoList(object:Object):Vector.<ObjectAttributeInfo>
		{
			var objectAttributeInfos:Vector.<ObjectAttributeInfo> = new Vector.<ObjectAttributeInfo>();

			var cls:Class = ClassUtils.getClass(object);
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

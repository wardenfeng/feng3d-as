package me.feng.objectView.configs
{
	import flash.utils.Dictionary;

	import avmplus.getQualifiedClassName;

	import me.feng.objectView.base.view.DefaultBaseObjectView;
	import me.feng.objectView.base.view.DefaultObjectAttributeView;
	import me.feng.objectView.base.view.DefaultObjectView;
	import me.feng.objectView.block.view.DefaultObjectAttributeBlockView;
	import me.feng.objectView.block.view.DefaultObjectViewWithBlock;
	import me.feng.utils.ClassUtils;

	/**
	 * ObjectView总配置数据
	 * @author feng 2016-3-23
	 */
	public class ObjectViewConfigVO
	{
		private var _defaultBaseObjectViewClass:Class = DefaultBaseObjectView;
		private var _defaultObjectViewClass:Class = DefaultObjectViewWithBlock;
		private var _defaultObjectAttributeViewClass:Class = DefaultObjectAttributeView;
		private var _defaultObjectAttributeBlockView:Class = DefaultObjectAttributeBlockView;

		/**
		 * 指定属性类型界面类定义字典（key:属性类名称,value:属性界面类定义）
		 */
		private const attributeDefaultViewClassByTypeDic:Dictionary = new Dictionary();

		/**
		 * ObjectView类配置字典 （key：类名称，value：ObjectView类配置）
		 */
		private var classConfigDic:Dictionary = new Dictionary();

		/**
		 * 属性块默认界面
		 */
		public function get defaultObjectAttributeBlockView():Class
		{
			return _defaultObjectAttributeBlockView;
		}

		/**
		 * @private
		 */
		public function set defaultObjectAttributeBlockView(value:*):void
		{
			value = ClassUtils.getClass(value);
			if (value != null)
			{
				_defaultObjectAttributeBlockView = value;
			}
		}

		/**
		 * 默认对象属性界面类定义
		 */
		public function get defaultObjectAttributeViewClass():Class
		{
			return _defaultObjectAttributeViewClass;
		}

		/**
		 * @private
		 */
		public function set defaultObjectAttributeViewClass(value:*):void
		{
			value = ClassUtils.getClass(value);
			if (value != null)
			{
				_defaultObjectAttributeViewClass = value;
			}
		}

		/**
		 * 默认对象界面类定义
		 */
		public function get defaultObjectViewClass():Class
		{
			return _defaultObjectViewClass;
		}

		/**
		 * @private
		 */
		public function set defaultObjectViewClass(value:*):void
		{
			value = ClassUtils.getClass(value);
			if (value != null)
			{
				_defaultObjectViewClass = value;
			}
		}

		/**
		 * 默认基础类型对象界面类定义
		 */
		public function get defaultBaseObjectViewClass():Class
		{
			return _defaultBaseObjectViewClass;
		}

		/**
		 * @private
		 */
		public function set defaultBaseObjectViewClass(value:*):void
		{
			value = ClassUtils.getClass(value);
			if (value != null)
			{
				_defaultBaseObjectViewClass = value;
			}
		}

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
		public function getAttributeDefaultViewClassByType(type:String):Class
		{
			return attributeDefaultViewClassByTypeDic[type];
		}

		/**
		 * 设置特定类型的默认属性界面类定义
		 * @param attributeClass			特定类型
		 * @param viewClass					属性界面类定义
		 */
		public function setAttributeDefaultViewClassByType(attributeClass:Object, viewClass:Object):void
		{
			var attributeCls:Class = ClassUtils.getClass(attributeClass);
			if (attributeCls == null)
			{
				return;
			}
			var attributeClassName:String = getQualifiedClassName(attributeCls);

			var cls:Class = ClassUtils.getClass(viewClass);
			attributeDefaultViewClassByTypeDic[attributeClassName] = cls;
		}

		/**
		 * 转化为对象
		 */
		public function getObject():Object
		{
			var data:Object = {};
			data.defaultBaseObjectViewClass = getQualifiedClassName(defaultBaseObjectViewClass);
			data.defaultObjectViewClass = getQualifiedClassName(defaultObjectViewClass);
			data.defaultObjectAttributeViewClass = getQualifiedClassName(defaultObjectAttributeViewClass);
			data.defaultObjectAttributeBlockView = getQualifiedClassName(defaultObjectAttributeBlockView);

			var attributeDefaultViews:Array = data.attributeDefaultViews = [];
			for (var attributeClassName:String in attributeDefaultViewClassByTypeDic)
			{
				if (attributeDefaultViewClassByTypeDic[attributeClassName] == null)
					continue;
				var attributeViewClassName:String = getQualifiedClassName(attributeDefaultViewClassByTypeDic[attributeClassName]);
				attributeDefaultViews.push({attributeType: attributeClassName, viewType: attributeViewClassName}); //
			}

			var classConfigs:Array = data.classConfigs = [];
			for (var className:String in classConfigDic)
			{
				var classConfig:ObjectViewClassConfig = classConfigDic[className];
				if (classConfig.isEmpty())
					continue;
				classConfigs.push({className: className, classConfig: classConfig.getObject()});
			}

			return data;
		}

		/**
		 * 设置数据
		 */
		public function setObject(data:Object):void
		{
			defaultBaseObjectViewClass = data.defaultBaseObjectViewClass;
			defaultObjectViewClass = data.defaultObjectViewClass;
			defaultObjectAttributeViewClass = data.defaultObjectAttributeViewClass;
			defaultObjectAttributeBlockView = data.defaultObjectAttributeBlockView;

			if (data.attributeDefaultViews != null)
			{
				for each (var attributeDefaultView:Object in data.attributeDefaultViews)
				{
					attributeDefaultViewClassByTypeDic[attributeDefaultView.attributeType] = //
						ClassUtils.getClass(attributeDefaultView.viewType);
				}
			}

			if (data.classConfigs != null)
			{
				for each (var object:Object in data.classConfigs)
				{
					var classConfig:ObjectViewClassConfig = classConfigDic[object.className] = new ObjectViewClassConfig();
					classConfig.setObject(object.classConfig);
				}
			}
		}

		/**
		 * 清除数据
		 */
		public function clear():void
		{
			defaultBaseObjectViewClass = DefaultBaseObjectView;
			defaultObjectViewClass = DefaultObjectView;
			defaultObjectAttributeViewClass = DefaultObjectAttributeView;
			defaultObjectAttributeBlockView = DefaultObjectAttributeBlockView;

			clearDic(attributeDefaultViewClassByTypeDic);
			clearDic(classConfigDic);
		}

		/**
		 * 清除字典
		 * @param dic
		 */
		private function clearDic(dic:Object):void
		{
			var keys:Array = [];
			for (var key:* in dic)
			{
				keys.push(key);
			}
			for (var i:int = 0; i < keys.length; i++)
			{
				var obj:Object = dic[keys[i]];
				if (obj != null && obj.hasOwnProperty("clear") && (obj["clear"] is Function))
				{
					obj["clear"]();
				}
				delete dic[keys[i]];
			}
		}
	}
}

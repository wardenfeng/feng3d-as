package me.feng.objectView
{
	import me.feng.objectView.configs.ObjectViewClassConfig;
	import me.feng.objectView.configs.ObjectViewConfigVO;

	/**
	 * ObjectView配置
	 * @author feng 2016-3-23
	 */
	public class ObjectViewConfig
	{
		/**
		 * ObjectView总配置数据
		 */
		internal static const objectViewConfigVO:ObjectViewConfigVO = new ObjectViewConfigVO();

		/**
		 * 设置自定义对象界面类定义
		 * @param object				指定对象类型
		 * @param viewClass				自定义对象界面类定义（该类必须是实现IObjectView接口并且是DisplayObject的子类）
		 */
		public static function setCustomObjectViewClass(objectClass:Class, viewClass:Class):void
		{
			var objectViewClassConfig:ObjectViewClassConfig = objectViewConfigVO.getClassConfig(objectClass);
			objectViewClassConfig.customObjectViewClass = viewClass;
		}

		/**
		 * 设置自定义对象属性界面类定义
		 * @param owner					属性拥有者
		 * @param attributeName			属性名称
		 * @param viewClass				自定义对象属性界面类定义（该类必须是实现IObjectAttributeView接口并且是DisplayObject的子类）
		 */
		public static function setCustomObjectAttributeViewClass(owner:Object, attributeName:String, viewClass:Object):void
		{
			var objectViewClassConfig:ObjectViewClassConfig = objectViewConfigVO.getClassConfig(owner);
			objectViewClassConfig.setAttributeDefinitionViewClass(attributeName, viewClass);
		}

		/**
		 * 设置特定类型的默认属性界面类定义
		 * @param attributeClass			特定类型
		 * @param viewClass					属性界面类
		 */
		public static function setAttributeDefaultViewClass(attributeClass:Object, viewClass:Object):void
		{
			objectViewConfigVO.setAttributeDefaultViewClassByType(attributeClass, viewClass);
		}

		/**
		 * 设置对象属性所在的属性块名称
		 * @param owner				属性拥有者
		 * @param attrName			属性名称
		 * @param blockName			所在属性块名称
		 */
		public static function setObjectAttributeBlockName(owner:Object, attrName:String, blockName:String):void
		{
			var objectViewClassConfig:ObjectViewClassConfig = objectViewConfigVO.getClassConfig(owner);
			objectViewClassConfig.setAttributeBlockName(attrName, blockName);
		}

		/**
		 * 设置自定义对象属性块界面类定义
		 * @param owner						块拥有者
		 * @param blockName					块名称
		 * @param blockView					自定义块界面
		 */
		public static function setCustomObjectAttributeBlockViewClass(owner:Object, blockName:String, blockView:Object):void
		{
			var objectViewClassConfig:ObjectViewClassConfig = objectViewConfigVO.getClassConfig(owner);
			objectViewClassConfig.setCustomBlockViewClass(blockName, blockView);
		}

		/**
		 * 设置类配置
		 * @param cls
		 * @param config
		 */
		public static function setClassConfig(object:Object, config:Object):void
		{
			var objectViewClassConfig:ObjectViewClassConfig = objectViewConfigVO.getClassConfig(object);
			objectViewClassConfig.clear();

			if (config.view != null)
			{
				objectViewClassConfig.customObjectViewClass = config.view;
			}
			if (config.attributeDefinitions != null)
			{
				for (var attributeName:String in config.attributeDefinitions)
				{
					setObjectAttributeBlockName(object, attributeName, config.attributeDefinitions[attributeName].block);
					setCustomObjectAttributeViewClass(object, attributeName, config.attributeDefinitions[attributeName].view);
				}
			}
			if (config.blockDefinitions != null)
			{
				var i:int = 0;
				for (i = 0; i < config.blockDefinitions.length; i++)
				{
					setCustomObjectAttributeBlockViewClass(object, config.blockDefinitions[i].name, config.blockDefinitions[i].view);
				}
			}
		}

		/**
		 * 设置完整配置
		 */
		public static function setFullConfig(config:Object):void
		{
			objectViewConfigVO.setObject(config);
		}

		/**
		 *	获取完整配置
		 */
		public static function getFullConfig():Object
		{
			return objectViewConfigVO.getObject();
		}

		public static function clearFullConfig():void
		{
			objectViewConfigVO.clear();
		}
	}
}

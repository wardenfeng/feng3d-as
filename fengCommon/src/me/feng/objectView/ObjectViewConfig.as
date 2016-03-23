package me.feng.objectView
{
	import me.feng.objectView.base.utils.ObjectAttributeUtils;
	import me.feng.objectView.base.utils.ObjectViewUtils;
	import me.feng.objectView.block.utils.ObjectAttributeBlockUtils;
	import me.feng.objectView.configs.ObjectViewConfigVO;
	import me.feng.utils.ClassUtils;


	/**
	 * ObjectView配置
	 * @author feng 2016-3-23
	 */
	public class ObjectViewConfig
	{
		internal static const objectViewConfigVO:ObjectViewConfigVO = new ObjectViewConfigVO();

		/**
		 * 设置自定义对象界面类定义
		 * @param object				指定对象类型
		 * @param viewClass				自定义对象界面类定义（该类必须是实现IObjectView接口并且是DisplayObject的子类）
		 */
		public static function setCustomObjectViewClass(objectClass:Class, viewClass:Class):void
		{
			objectViewUtils.setCustomObjectViewClass(objectClass, viewClass);
		}

		/**
		 * 设置自定义对象属性界面类定义
		 * @param owner					属性拥有者
		 * @param attributeName			属性名称
		 * @param viewClass				自定义对象属性界面类定义（该类必须是实现IObjectAttributeView接口并且是DisplayObject的子类）
		 */
		public static function setCustomObjectAttributeViewClass(owner:Object, attributeName:String, viewClass:Object):void
		{
			objectAttributeUtils.setCustomObjectAttributeViewClass(owner, attributeName, viewClass);
		}

		/**
		 * 设置特定类型的默认属性界面类定义
		 * @param attributeClass			特定类型
		 * @param viewClass					属性界面类
		 */
		public static function setAttributeDefaultViewClass(attributeClass:Object, viewClass:Object):void
		{
			objectAttributeUtils.setAttributeDefaultViewClass(attributeClass, viewClass);
		}

		/**
		 * 设置对象属性所在的属性块名称
		 * @param owner				属性拥有者
		 * @param attrName			属性名称
		 * @param blockName			所在属性块名称
		 */
		public static function setObjectAttributeBlockName(owner:Object, attrName:String, blockName:String):void
		{
			objectAttributeBlockUtils.setObjectAttributeBlockName(owner, attrName, blockName);
		}

		/**
		 * 设置自定义对象属性块界面类定义
		 * @param owner						块拥有者
		 * @param blockName					块名称
		 * @param blockView					自定义块界面
		 */
		public static function setCustomObjectAttributeBlockViewClass(owner:Object, blockName:String, blockView:Object):void
		{
			objectAttributeBlockUtils.setCustomObjectAttributeBlockViewClass(owner, blockName, blockView);
		}

		/**
		 * 设置类配置
		 * @param cls
		 * @param config
		 */
		public static function setClassConfig(object:Object, config:Object):void
		{
			var objectClass:Class = ClassUtils.getClass(object);


			if (config.view != null)
			{
				setCustomObjectViewClass(objectClass, ClassUtils.getClass(config.view));
			}
			var i:int = 0;
			if (config.attributeDefinitions != null)
			{
				for (i = 0; i < config.attributeDefinitions.length; i++)
				{
					setObjectAttributeBlockName(object, config.attributeDefinitions[i].name, config.attributeDefinitions[i].block);
					setCustomObjectAttributeViewClass(object, config.attributeDefinitions[i].name, config.attributeDefinitions[i].view);
				}
			}
			if (config.blockDefinitions != null)
			{
				for (i = 0; i < config.blockDefinitions.length; i++)
				{
					setCustomObjectAttributeBlockViewClass(object, config.blockDefinitions[i].name, config.blockDefinitions[i].view);
				}
			}
		}

		public static function setGlobalConfig(config:Object):void
		{
			if (config.attributeDefaultViews != null)
			{
				for (var i:int = 0; i < config.attributeDefaultViews.length; i++)
				{
					(config.attributeDefaultViews[i].attributeType, config.attributeDefaultViews[i].viewType);
				}
			}
		}

		/**
		 * 对象界面工具
		 */
		private static function get objectViewUtils():ObjectViewUtils
		{
			return ObjectView.objectViewUtils;
		}

		/**
		 * 对象属性工具
		 */
		private static function get objectAttributeUtils():ObjectAttributeUtils
		{
			return ObjectView.objectAttributeUtils;
		}

		/**
		 * 对象属性块工具
		 */
		private static function get objectAttributeBlockUtils():ObjectAttributeBlockUtils
		{
			return ObjectView.objectAttributeBlockUtils;
		}
	}
}

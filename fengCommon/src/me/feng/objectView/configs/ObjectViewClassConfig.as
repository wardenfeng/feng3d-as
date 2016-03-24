package me.feng.objectView.configs
{
	import flash.utils.Dictionary;

	import me.feng.utils.ClassUtils;

	/**
	 * ObjectView类配置
	 * @author feng 2016-3-23
	 */
	public class ObjectViewClassConfig
	{
		/**
		 * 自定义对象属性定义字典（key:属性名,value:属性定义）
		 */
		private const attributeDefinitionDic:Dictionary = new Dictionary();

		/**
		 * 自定义对象属性块界面类定义字典（key:属性块名称,value:自定义对象属性块界面类定义）
		 */
		private const blockDefinitionDic:Dictionary = new Dictionary();
		private var _customObjectViewClass:Class;

		/**
		 * 自定义对象界面类定义
		 */
		public function get customObjectViewClass():Class
		{
			return _customObjectViewClass;
		}

		/**
		 * @private
		 */
		public function set customObjectViewClass(value:*):void
		{
			_customObjectViewClass = ClassUtils.getClass(value);
		}

		public function clear():void
		{
			customObjectViewClass = null;

			clearDic(attributeDefinitionDic);
			clearDic(blockDefinitionDic);
		}

		/**
		 * 清除字典
		 * @param dic
		 */
		private function clearDic(dic:Dictionary):void
		{
			var keys:Array = [];
			for (var key:* in dic)
			{
				keys.push(key);
			}
			for (var i:int = 0; i < keys.length; i++)
			{
				delete dic[keys[i]];
			}
		}

		/**
		 * 设置自定义对象属性界面类定义
		 * @param attributeName			属性名称
		 * @param viewClass				自定义对象属性界面类定义（该类必须是实现IObjectAttributeView接口并且是DisplayObject的子类）
		 */
		public function setAttributeDefinitionViewClass(attributeName:String, viewClass:Object):void
		{
			var cls:Class = ClassUtils.getClass(viewClass);
			var attributeDefinition:ObjectViewAttributeDefinition = getAttributeDefinition(attributeName);
			attributeDefinition.view = cls;
		}

		/**
		 * 获取自定义对象属性界面类定义
		 * @param attributeName			属性名称
		 * @return
		 */
		public function getAttributeDefinitionViewClass(attributeName:String):Class
		{
			var attributeDefinition:ObjectViewAttributeDefinition = getAttributeDefinition(attributeName);
			return attributeDefinition.view;
		}

		/**
		 * 获取自定义对象属性定义
		 * @param attributeName
		 * @return
		 */
		private function getAttributeDefinition(attributeName:String):ObjectViewAttributeDefinition
		{
			if (attributeDefinitionDic[attributeName] == null)
			{
				attributeDefinitionDic[attributeName] = new ObjectViewAttributeDefinition();
			}
			return attributeDefinitionDic[attributeName];
		}

		/**
		 * 设置对象属性所在的属性块名称
		 * @param attributeName			属性名称
		 * @param blockName				块名称
		 */
		public function setAttributeBlockName(attributeName:String, blockName:String):void
		{
			var attributeDefinition:ObjectViewAttributeDefinition = getAttributeDefinition(attributeName);
			attributeDefinition.block = blockName;
		}

		/**
		 * 获取对象属性块名称
		 * @param attrName			属性名称
		 * @return
		 */
		public function getAttributeBlockName(attributeName:String):String
		{
			var attributeDefinition:ObjectViewAttributeDefinition = getAttributeDefinition(attributeName);
			return attributeDefinition.block;
		}

		/**
		 * 设置自定义对象属性块界面类定义
		 * @param blockName					块名称
		 * @param blockView					自定义块界面
		 */
		public function setCustomBlockViewClass(blockName:String, blockView:Object):void
		{
			var viewClass:Class = ClassUtils.getClass(blockView);
			blockDefinitionDic[blockName] = viewClass;
		}

		/**
		 * 获取自定义对象属性块界面类定义
		 * @param blockName					块名称
		 * @return
		 */
		public function getCustomBlockViewClass(blockName:String):Class
		{
			return blockDefinitionDic[blockName];
		}
	}
}

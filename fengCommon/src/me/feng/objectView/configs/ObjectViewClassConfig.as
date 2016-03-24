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
		 * 自定义对象属性界面类定义字典（key:属性名,value:属性界面类定义）
		 */
		private const attributeDefinitionDic:Dictionary = new Dictionary();
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
		public function setAttributeDefinition(attributeName:String, viewClass:Object):void
		{
			var cls:Class = ClassUtils.getClass(viewClass);
			attributeDefinitionDic[attributeName] = cls;
		}

		/**
		 * 获取自定义对象属性界面类定义
		 * @param attributeName			属性名称
		 * @return
		 */
		public function getAttributeDefinition(attributeName:String):Class
		{
			return attributeDefinitionDic[attributeName];
		}
	}
}

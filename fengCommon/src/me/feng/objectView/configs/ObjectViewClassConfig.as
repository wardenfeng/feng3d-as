package me.feng.objectView.configs
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	import me.feng.objectView.base.data.ObjectAttributeInfo;
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
		private var attributeDefinitionDic:Dictionary = new Dictionary();

		/**
		 * 属性列表（排序结果）
		 */
		private var attributeSortArr:Array;

		/**
		 * 自定义对象属性块界面类定义字典（key:属性块名称,value:自定义对象属性块界面类定义）
		 */
		private var blockDefinitionDic:Dictionary = new Dictionary();

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

		/**
		 * 数据是否为空
		 */
		public function isEmpty():Boolean
		{
			if (customObjectViewClass != null)
				return false;

			var value:Object;
			for each (value in attributeDefinitionDic)
			{
				if (value != null)
					return false;
			}

			for each (value in blockDefinitionDic)
			{
				if (value != null)
					return false;
			}

			return true;
		}

		/**
		 * 清理数据
		 */
		public function clear():void
		{
			customObjectViewClass = null;

			clearDic(attributeDefinitionDic);
			clearDic(blockDefinitionDic);
		}

		/**
		 * 转化为对象
		 */
		public function getObject():Object
		{
			var object:Object = {};
			var viewClassName:String = getQualifiedClassName(customObjectViewClass);
			if (viewClassName != null)
			{
				object.view = viewClassName;
			}

			var attributeDefinitions:Array = object.attributeDefinitions = [];

			for (var i:int = 0; i < attributeSortArr.length; i++)
			{
				var attributeName:String = attributeSortArr[i];
				var attributeDefinition:ObjectViewAttributeDefinition = attributeDefinitionDic[attributeName];
				if (attributeDefinition == null || attributeDefinition.isEmpty())
					continue;
				attributeDefinitions.push(attributeDefinition.getObject());
			}

			var blockDefinitions:Array = object.blockDefinitions = [];
			for (var blockName:String in blockDefinitionDic)
			{
				if (blockDefinitionDic[blockName] != null)
				{
					blockDefinitions.push({name: blockName, view: getQualifiedClassName(blockDefinitionDic[blockName])});
				}
			}

			return object;
		}

		/**
		 * 设置数据
		 */
		public function setObject(object:Object):void
		{
			customObjectViewClass = ClassUtils.getClass(object.view);

			attributeSortArr = [];
			if (object.attributeDefinitions != null)
			{
				for each (var attributeDefinitionData:Object in object.attributeDefinitions)
				{
					var attributeDefinition:ObjectViewAttributeDefinition = getAttributeDefinition(attributeDefinitionData.name);
					attributeDefinition.setObject(attributeDefinitionData);
					attributeSortArr.push(attributeDefinition.name);
				}
			}

			if (object.blockDefinitions != null)
			{
				for each (var blockDefinition:Object in object.blockDefinitions)
				{
					blockDefinitionDic[blockDefinition.name] = ClassUtils.getClass(blockDefinition.view);
				}
			}
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
				var attributeDefinition:ObjectViewAttributeDefinition = attributeDefinitionDic[attributeName] = new ObjectViewAttributeDefinition();
				attributeDefinition.name = attributeName;
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

		/**
		 * 给属性排序
		 * @param objectAttributeInfos
		 */
		public function sort(objectAttributeInfos:Vector.<ObjectAttributeInfo>):void
		{
			var arr:Array = [];
			var dic:Dictionary = new Dictionary();
			var attributeInfo:ObjectAttributeInfo;
			for each (attributeInfo in objectAttributeInfos)
			{
				arr.push(attributeInfo.name);
				dic[attributeInfo.name] = attributeInfo;
			}
			arr.sort();

			sortArr(attributeSortArr, arr);
			attributeSortArr = arr.concat();

			objectAttributeInfos.length = 0;
			for (var i:int = 0; i < arr.length; i++)
			{
				objectAttributeInfos.push(dic[arr[i]]);
			}
		}

		/**
		 * 根据老数组中的位置排序新数组（尽可能保留老数组中的顺序）
		 * @param oldArr			老数组
		 * @param newArr			新数组
		 */
		private function sortArr(oldArr:Array, newArr:Array):void
		{
			if (oldArr == null)
				return;

			var i:int;
			//删除无效属性
			for (i = oldArr.length - 1; i >= 0; i--)
			{
				var index:int = newArr.indexOf(oldArr[i]);
				if (index != -1)
				{
					//把元素移到数组头部
					newArr.splice(index, 1);
					newArr.unshift(oldArr[i]);
				}
			}
		}
	}
}

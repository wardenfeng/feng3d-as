package me.feng.objectView.block.utils
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	import avmplus.getQualifiedClassName;

	import me.feng.objectView.ObjectView;
	import me.feng.objectView.base.data.ObjectAttributeInfo;
	import me.feng.objectView.block.IObjectAttributeBlockView;
	import me.feng.objectView.block.data.ObjectAttributeBlock;
	import me.feng.objectView.block.view.DefaultObjectAttributeBlockView;

	/**
	 * 对象属性块工具
	 * @author feng 2016-3-22
	 */
	public class ObjectAttributeBlockUtils
	{
		/**
		 * 属性块默认界面
		 */
		private var objectAttributeBlockView:Class = DefaultObjectAttributeBlockView;

		/**
		 * 对象属性块字典		（key:对象属性块全局名称,value:对象属性块）
		 */
		private const objectAttributeBlockDic:Dictionary = new Dictionary();

		/**
		 * 对象属性块名称字典		（key:类属性ID,value:对象属性块名称）
		 */
		private const objectAttributeBlockNameDic:Dictionary = new Dictionary();

		/**
		 * 自定义对象属性块界面类定义字典（key:属性块全局名称,value:自定义对象属性块界面类定义）
		 */
		private var customObjectAttributeViewClassDic:Dictionary = new Dictionary();

		/**
		 * 获取对象属性块界面
		 * @param objectAttributeBlock		对象属性块信息
		 * @return							对象属性块界面
		 */
		public function getObjectAttributeBlockView(objectAttributeBlock:ObjectAttributeBlock):DisplayObject
		{
			var viewClass:Class = getObjectAttributeBlockViewClass(objectAttributeBlock.owner, objectAttributeBlock.blockName);
			var view:DisplayObject = new viewClass();
			IObjectAttributeBlockView(view).objectAttributeBlock = objectAttributeBlock;
			return view;
		}

		/**
		 * 设置对象属性所在的属性块名称
		 * @param owner				属性拥有者
		 * @param attrName			属性名称
		 * @param blockName			所在属性块名称
		 */
		public function setObjectAttributeBlockName(owner:Object, attrName:String, blockName:String):void
		{
			var key:String = ObjectView.getClassAttributeID(owner, attrName);
			objectAttributeBlockNameDic[key] = blockName;
		}

		/**
		 * 获取对象属性块列表
		 * @param object		指定对象
		 * @return
		 */
		public function getObjectAttributeBlocks(object:Object):Vector.<ObjectAttributeBlock>
		{
			var objectAttributeInfos:Vector.<ObjectAttributeInfo> = ObjectView.getObjectAttributeInfos(object);

			var objectAttributeBlocks:Vector.<ObjectAttributeBlock> = getObjectAttributeBlocksByObjectAttributeInfos(objectAttributeInfos);
			return objectAttributeBlocks;
		}

		/**
		 * 获取对象属性块列表
		 * @param objectAttributeInfos		对象属性信息列表
		 * @return
		 */
		private function getObjectAttributeBlocksByObjectAttributeInfos(objectAttributeInfos:Vector.<ObjectAttributeInfo>):Vector.<ObjectAttributeBlock>
		{
			var objectAttributeBlocks:Vector.<ObjectAttributeBlock> = new Vector.<ObjectAttributeBlock>();

			var blockDic:Dictionary = new Dictionary();

			var objectAttributeBlock:ObjectAttributeBlock;
			for (var i:int = 0; i < objectAttributeInfos.length; i++)
			{
				objectAttributeBlock = getBlockByAttrName(objectAttributeInfos[i].owner, objectAttributeInfos[i].name);
				if (!Boolean(blockDic[objectAttributeBlock]))
				{
					blockDic[objectAttributeBlock] = true;
					objectAttributeBlocks.push(objectAttributeBlock);
				}
				objectAttributeBlock.itemList.push(objectAttributeInfos[i]);
			}

			return objectAttributeBlocks;
		}

		/**
		 * 根据属性名获取对象属性块
		 * @param owner				属性拥有者
		 * @param attrName			属性名称
		 * @return
		 */
		private function getBlockByAttrName(owner:Object, attrName:String):ObjectAttributeBlock
		{
			var blockName:String = getObjectAttributeBlockName(owner, attrName);
			var objectAttributeBlock:ObjectAttributeBlock = getBlockByName(owner, blockName);
			return objectAttributeBlock;
		}

		/**
		 * 根据名称获取对象属性块
		 * @param owner				块拥有者
		 * @param blockName			块名称
		 * @return
		 */
		private function getBlockByName(owner:Object, blockName:String):ObjectAttributeBlock
		{
			var blockGlobalName:String = getGlobalBlockName(owner, blockName);

			var objectAttributeBlock:ObjectAttributeBlock = objectAttributeBlockDic[blockGlobalName];
			if (objectAttributeBlock == null)
			{
				objectAttributeBlock = objectAttributeBlockDic[blockGlobalName] = new ObjectAttributeBlock();
				objectAttributeBlock.owner = owner;
				objectAttributeBlock.blockName = blockName;
			}

			return objectAttributeBlockDic[blockGlobalName];
		}

		/**
		 * 获取对象属性块名称
		 * @param owner				属性拥有者
		 * @param attrName			属性名称
		 * @return
		 */
		private function getObjectAttributeBlockName(owner:Object, attrName:String):String
		{
			var key:String = ObjectView.getClassAttributeID(owner, attrName);
			var blockName:String = objectAttributeBlockNameDic[key];

			var globalBlockName:String = getQualifiedClassName(owner);
			if (blockName != null)
			{
				globalBlockName = globalBlockName + "-" + blockName;
			}
			return globalBlockName;
		}

		/**
		 * 获取对象属性块界面类定义
		 * @param objectAttributeBlock		对象属性快信息
		 * @return							对象属性块界面类定义
		 */
		private function getObjectAttributeBlockViewClass(owner:Object, blockName:String):Class
		{
			//获取自定义对象属性界面类定义
			var viewClass:Class = getCustomObjectAttributeBlockViewClass(owner, blockName);
			if (viewClass != null)
				return viewClass;

			//返回默认对象属性界面类定义
			return objectAttributeBlockView;
		}

		/**
		 * 获取自定义对象属性块界面类定义
		 * @param blockGlobalName			属性块全局名称
		 * @return							自定义对象属性块界面类定义
		 */
		private function getCustomObjectAttributeBlockViewClass(owner:Object, blockName:String):Class
		{
			var globalBlockName:String = getGlobalBlockName(owner, blockName);
			var viewClass:Class = customObjectAttributeViewClassDic[globalBlockName];
			return viewClass;
		}

		/**
		 * 获取块全局名称
		 * @param owner				块拥有者
		 * @param blockName			块名称
		 * @return
		 */
		private function getGlobalBlockName(owner:Object, blockName:String):String
		{
			var globalBlockName:String = getQualifiedClassName(owner);

			if (blockName != null)
			{
				globalBlockName = globalBlockName + "-" + blockName;
			}
			return globalBlockName;
		}
	}
}

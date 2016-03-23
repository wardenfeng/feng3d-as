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
				objectAttributeBlock = getObjectAttributeBlockByObjectAttributeInfo(objectAttributeInfos[i]);
				if (!Boolean(blockDic[objectAttributeBlock]))
				{
					blockDic[objectAttributeBlock] = true;
					objectAttributeBlocks.push(objectAttributeBlock);
				}
				objectAttributeBlock.itemList.push(objectAttributeInfos[i]);
			}

			return objectAttributeBlocks;
		}

		private function getObjectAttributeBlockByObjectAttributeInfo(objectAttributeInfo:ObjectAttributeInfo):ObjectAttributeBlock
		{
			var blockGlobalName:String = getObjectAttributeBlockGlobalName(objectAttributeInfo.owner, objectAttributeInfo.name);

			var objectAttributeBlock:ObjectAttributeBlock = getBlockByBlockGlobalName(blockGlobalName);

			return objectAttributeBlock;
		}

		/**
		 * 获取对象属性块全局名称
		 * @param owner				属性拥有者
		 * @param attrName			属性名称
		 * @return
		 */
		private function getObjectAttributeBlockGlobalName(owner:Object, attrName:String):String
		{
			var globalBlockName:String = getQualifiedClassName(owner);

			var blockName:String = getObjectAttributeBlockName(owner, attrName);
			if (blockName != null)
			{
				globalBlockName = globalBlockName + "-" + blockName;
			}
			return globalBlockName;
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
			return blockName;
		}

		/**
		 * 根据全局名称获取对象属性块
		 * @param blockGlobalName		对象属性块全局名称
		 * @return
		 */
		private function getBlockByBlockGlobalName(blockGlobalName:String):ObjectAttributeBlock
		{
			var objectAttributeBlock:ObjectAttributeBlock = objectAttributeBlockDic[blockGlobalName];
			if (objectAttributeBlock == null)
			{
				objectAttributeBlock = objectAttributeBlockDic[blockGlobalName] = new ObjectAttributeBlock();
				objectAttributeBlock.blockGlobalName = blockGlobalName;

				var blockName:String = blockGlobalName.split("-")[1];

				if (blockName != null)
				{
					objectAttributeBlock.blockName = blockName;
				}
			}

			return objectAttributeBlockDic[blockGlobalName];
		}

		/**
		 * 获取对象属性块界面
		 * @param objectAttributeBlock		对象属性块信息
		 * @return							对象属性块界面
		 */
		public function getObjectAttributeBlockView(objectAttributeBlock:ObjectAttributeBlock):DisplayObject
		{
			var viewClass:Class = getObjectAttributeBlockViewClass(objectAttributeBlock);
			var view:DisplayObject = new viewClass();
			IObjectAttributeBlockView(view).objectAttributeBlock = objectAttributeBlock;
			return view;
		}

		/**
		 * 获取对象属性块界面类定义
		 * @param objectAttributeBlock		对象属性快信息
		 * @return							对象属性块界面类定义
		 */
		private function getObjectAttributeBlockViewClass(objectAttributeBlock:ObjectAttributeBlock):Class
		{
			//获取自定义对象属性界面类定义
			var viewClass:Class = getCustomObjectAttributeBlockViewClass(objectAttributeBlock.blockGlobalName);
			if (viewClass != null)
				return viewClass;

			//返回默认对象属性界面类定义
			return DefaultObjectAttributeBlockView;
		}

		/**
		 * 获取自定义对象属性块界面类定义
		 * @param blockGlobalName			属性块全局名称
		 * @return							自定义对象属性块界面类定义
		 */
		private function getCustomObjectAttributeBlockViewClass(blockGlobalName:String):Class
		{
			var viewClass:Class = customObjectAttributeViewClassDic[blockGlobalName];
			return viewClass;
		}
	}
}

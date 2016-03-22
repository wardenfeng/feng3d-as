package me.feng.objectView.utils
{
	import flash.utils.Dictionary;

	import avmplus.getQualifiedClassName;

	import me.feng.objectView.ObjectView;
	import me.feng.objectView.data.ObjectAttributeBlock;
	import me.feng.objectView.data.ObjectAttributeInfo;

	/**
	 * 对象属性块工具
	 * @author feng 2016-3-22
	 */
	public class ObjectAttributeBlockUtils
	{
		/**
		 * 对象属性块字典		（key:对象属性块全局名称,value:对象属性块）
		 */
		private static const objectAttributeBlockDic:Dictionary = new Dictionary();
		/**
		 * 对象属性块名称字典		（key:类属性ID,value:对象属性块名称）
		 */
		private static const objectAttributeBlockNameDic:Dictionary = new Dictionary();

		/**
		 * 获取对象属性块列表
		 * @param object		指定对象
		 * @return
		 */
		public static function getObjectAttributeBlocks(object:Object):Vector.<ObjectAttributeBlock>
		{
			var objectAttributeInfos:Vector.<ObjectAttributeInfo> = ObjectAttributeUtils.getObjectAttributeInfos(object);

			var objectAttributeBlocks:Vector.<ObjectAttributeBlock> = getObjectAttributeBlocksByObjectAttributeInfos(objectAttributeInfos);
			return objectAttributeBlocks;
		}

		/**
		 * 获取对象属性块列表
		 * @param objectAttributeInfos		对象属性信息列表
		 * @return
		 */
		private static function getObjectAttributeBlocksByObjectAttributeInfos(objectAttributeInfos:Vector.<ObjectAttributeInfo>):Vector.<ObjectAttributeBlock>
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

		private static function getObjectAttributeBlockByObjectAttributeInfo(objectAttributeInfo:ObjectAttributeInfo):ObjectAttributeBlock
		{
			var blockGlobalName:String = getObjectAttributeBlockGlobalName(objectAttributeInfo.owner, objectAttributeInfo.name);

			var objectAttributeBlock:ObjectAttributeBlock = getBlockByBlockGlobalName(blockGlobalName);

			return objectAttributeBlock;
		}

		/**
		 * 获取对象属性块全局名称
		 * @param owner
		 * @param attrName
		 * @return
		 */
		private static function getObjectAttributeBlockGlobalName(owner:Object, attrName:String):String
		{
			var globalBlockName:String = getQualifiedClassName(owner);

			var blockName:String = getObjectAttributeBlockName(owner, attrName);
			if (blockName != null)
			{
				globalBlockName = globalBlockName + "-" + blockName;
			}
			return globalBlockName;
		}

		private static function getObjectAttributeBlockName(owner:Object, attrName:String):String
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
		private static function getBlockByBlockGlobalName(blockGlobalName:String):ObjectAttributeBlock
		{
			var objectAttributeBlock:ObjectAttributeBlock = objectAttributeBlockDic[blockGlobalName];
			if (objectAttributeBlock == null)
			{
				objectAttributeBlock = objectAttributeBlockDic[blockGlobalName] = new ObjectAttributeBlock();

				var blockName:String = blockGlobalName.split("-")[1];

				if (blockName != null)
				{
					objectAttributeBlock.blockName = blockName;
				}
			}

			return objectAttributeBlockDic[blockGlobalName];
		}
	}
}

package me.feng.objectView.block.utils
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	import me.feng.objectView.ObjectView;
	import me.feng.objectView.base.data.ObjectAttributeInfo;
	import me.feng.objectView.block.IObjectAttributeBlockView;
	import me.feng.objectView.block.data.ObjectAttributeBlock;
	import me.feng.objectView.configs.ObjectViewClassConfig;
	import me.feng.objectView.configs.ObjectViewConfigVO;

	/**
	 * 对象属性块工具
	 * @author feng 2016-3-22
	 */
	public class ObjectAttributeBlockUtils
	{
		/**
		 * ObjectView总配置数据
		 */
		private var objectViewConfigVO:ObjectViewConfigVO;

		/**
		 * 构建
		 */
		public function ObjectAttributeBlockUtils(objectViewConfigVO:ObjectViewConfigVO)
		{
			this.objectViewConfigVO = objectViewConfigVO;
		}

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
				var blockName:String = getObjectAttributeBlockName(objectAttributeInfos[i].owner, objectAttributeInfos[i].name);
				objectAttributeBlock = blockDic[blockName];

				if (objectAttributeBlock == null)
				{
					objectAttributeBlock = blockDic[blockName] = new ObjectAttributeBlock();
					objectAttributeBlock.owner = objectAttributeInfos[i].owner;
					objectAttributeBlock.blockName = blockName;
					objectAttributeBlocks.push(objectAttributeBlock);
				}
				objectAttributeBlock.itemList.push(objectAttributeInfos[i]);
			}

			return objectAttributeBlocks;
		}

		/**
		 * 获取对象属性块名称
		 * @param owner				属性拥有者
		 * @param attrName			属性名称
		 * @return
		 */
		private function getObjectAttributeBlockName(owner:Object, attrName:String):String
		{
			var objectViewClassConfig:ObjectViewClassConfig = objectViewConfigVO.getClassConfig(owner);
			var blockName:String = objectViewClassConfig.getObjectAttributeBlockName(attrName);
			return blockName;
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
			return objectViewConfigVO.objectAttributeBlockView;
		}

		/**
		 * 获取自定义对象属性块界面类定义
		 * @param owner						块拥有者
		 * @param blockName					块名称
		 * @return
		 */
		private function getCustomObjectAttributeBlockViewClass(owner:Object, blockName:String):Class
		{
			var objectViewClassConfig:ObjectViewClassConfig = objectViewConfigVO.getClassConfig(owner);
			var viewClass:Class = objectViewClassConfig.getCustomObjectAttributeBlockViewClass(blockName);
			return viewClass;
		}
	}
}

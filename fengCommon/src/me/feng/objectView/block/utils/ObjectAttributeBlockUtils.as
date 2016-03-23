package me.feng.objectView.block.utils
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	import avmplus.getQualifiedClassName;

	import me.feng.objectView.ObjectView;
	import me.feng.objectView.base.data.ObjectAttributeInfo;
	import me.feng.objectView.block.IObjectAttributeBlockView;
	import me.feng.objectView.block.data.ObjectAttributeBlock;
	import me.feng.objectView.configs.ObjectViewConfigVO;
	import me.feng.utils.ClassUtils;

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
		 * 对象属性块名称字典		（key:类属性ID,value:对象属性块名称）
		 */
		private const objectAttributeBlockNameDic:Dictionary = new Dictionary();

		/**
		 * 自定义对象属性块界面类定义字典（key:属性块全局名称,value:自定义对象属性块界面类定义）
		 */
		private var customObjectAttributeViewClassDic:Dictionary = new Dictionary();

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
		 * 设置自定义对象属性块界面类定义
		 * @param owner						块拥有者
		 * @param blockName					块名称
		 * @param blockView					自定义块界面
		 */
		public function setCustomObjectAttributeBlockViewClass(owner:Object, blockName:String, blockView:Object):void
		{
			var globalBlockName:String = getGlobalBlockName(owner, blockName);
			var viewClass:Class = ClassUtils.getClass(blockView);
			customObjectAttributeViewClassDic[globalBlockName] = viewClass;
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
			var key:String = ObjectView.getClassAttributeID(owner, attrName);
			var blockName:String = objectAttributeBlockNameDic[key];
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

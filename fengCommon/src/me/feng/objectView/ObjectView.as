package me.feng.objectView
{
	import flash.display.DisplayObject;

	import avmplus.getQualifiedClassName;

	import me.feng.objectView.base.data.ObjectAttributeInfo;
	import me.feng.objectView.base.utils.ObjectAttributeUtils;
	import me.feng.objectView.base.utils.ObjectViewUtils;
	import me.feng.objectView.block.data.ObjectAttributeBlock;
	import me.feng.objectView.block.utils.ObjectAttributeBlockUtils;

	/**
	 * 对象界面
	 * @author feng 2016-3-10
	 */
	public class ObjectView
	{
		/**
		 * 对象界面工具
		 */
		internal static var objectViewUtils:ObjectViewUtils = new ObjectViewUtils(ObjectViewConfig.objectViewConfigVO);
		/**
		 * 对象属性工具
		 */
		internal static var objectAttributeUtils:ObjectAttributeUtils = new ObjectAttributeUtils(ObjectViewConfig.objectViewConfigVO);
		/**
		 * 对象属性块工具
		 */
		internal static var objectAttributeBlockUtils:ObjectAttributeBlockUtils = new ObjectAttributeBlockUtils(ObjectViewConfig.objectViewConfigVO);

		/**
		 * 获取对象界面
		 * @param object	用于生成界面的对象
		 */
		public static function getObjectView(object:Object):DisplayObject
		{
			var view:DisplayObject = objectViewUtils.getObjectView(object);
			return view;
		}

		/**
		 * 获取对象属性界面
		 * @param objectAttributeInfo		对象属性信息
		 * @return							对象属性界面
		 */
		public static function getObjectAttributeView(objectAttributeInfo:ObjectAttributeInfo):DisplayObject
		{
			var view:DisplayObject = objectAttributeUtils.getObjectAttributeView(objectAttributeInfo);
			return view;
		}

		/**
		 * 获取对象属性块界面
		 * @param objectAttributeBlock		对象属性块信息
		 * @return							对象属性块界面
		 */
		public static function getObjectAttributeBlockView(objectAttributeBlock:ObjectAttributeBlock):DisplayObject
		{
			var view:DisplayObject = objectAttributeBlockUtils.getObjectAttributeBlockView(objectAttributeBlock);
			return view;
		}

		/**
		 * 获取对象属性信息
		 * @param object		指定对象
		 * @return				属性信息
		 */
		public static function getObjectAttributeInfos(object:Object):Vector.<ObjectAttributeInfo>
		{
			var objectAttributeInfos:Vector.<ObjectAttributeInfo> = objectAttributeUtils.getObjectAttributeInfos(object);
			return objectAttributeInfos;
		}

		/**
		 * 获取对象属性块列表
		 * @param object		指定对象
		 * @return
		 */
		public static function getObjectAttributeBlocks(object:Object):Vector.<ObjectAttributeBlock>
		{
			var objectAttributeBlocks:Vector.<ObjectAttributeBlock> = objectAttributeBlockUtils.getObjectAttributeBlocks(object);
			return objectAttributeBlocks;
		}

		/**
		 * 获取类属性ID
		 * @param owner					属性拥有者
		 * @param attributeName			属性名称
		 * @return						类属性ID
		 */
		public static function getClassAttributeID(owner:Object, attributeName:String):String
		{
			var className:String = getQualifiedClassName(owner);
			var key:String = className + "-" + attributeName;
			return key;
		}
	}
}

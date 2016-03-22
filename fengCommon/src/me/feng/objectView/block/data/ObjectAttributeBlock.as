package me.feng.objectView.block.data
{
	import me.feng.objectView.base.data.ObjectAttributeInfo;

	/**
	 * 对象属性块
	 * @author feng 2016-3-22
	 */
	public class ObjectAttributeBlock
	{
		/**
		 * 块全局名称
		 */
		public var blockGlobalName:String;

		/**
		 * 块名称
		 */
		public var blockName:String;

		/**
		 * 属性信息列表
		 */
		public var itemList:Vector.<ObjectAttributeInfo>;


		/**
		 * 构建一个对象属性块
		 */
		public function ObjectAttributeBlock()
		{
			blockName = "";
			itemList = new Vector.<ObjectAttributeInfo>();
		}
	}
}

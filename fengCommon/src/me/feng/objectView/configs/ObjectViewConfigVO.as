package me.feng.objectView.configs
{
	import me.feng.objectView.base.view.DefaultBaseObjectView;
	import me.feng.objectView.base.view.DefaultObjectAttributeView;
	import me.feng.objectView.block.view.DefaultObjectAttributeBlockView;
	import me.feng.objectView.block.view.DefaultObjectViewWithBlock;

	/**
	 * ObjectView总配置数据
	 * @author feng 2016-3-23
	 */
	public class ObjectViewConfigVO
	{
		/**
		 * 默认基础类型对象界面类定义
		 */
		public var baseObjectViewClass:Class = DefaultBaseObjectView;

		/**
		 * 默认对象界面类定义
		 */
		//		public static var DefaultObjectViewClass:Class = DefaultObjectView;
		public var objectViewClass:Class = DefaultObjectViewWithBlock;

		/**
		 * 默认对象属性界面类定义
		 */
		public var objectAttributeViewClass:Class = DefaultObjectAttributeView;

		/**
		 * 属性块默认界面
		 */
		public var objectAttributeBlockView:Class = DefaultObjectAttributeBlockView;
	}
}

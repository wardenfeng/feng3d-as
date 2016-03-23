package me.feng.objectView
{
	import me.feng.objectView.base.view.DefaultBaseObjectView;
	import me.feng.objectView.block.view.DefaultObjectViewWithBlock;

	/**
	 * ObjectView配置
	 * @author feng 2016-3-23
	 */
	public class ObjectViewConfig
	{
		/**
		 * 默认基础类型对象界面类定义
		 */
		public static var DefaultBaseObjectViewClass:Class = DefaultBaseObjectView;

		/**
		 * 默认对象界面类定义
		 */
		//		public static var DefaultObjectViewClass:Class = DefaultObjectView;
		public static var DefaultObjectViewClass:Class = DefaultObjectViewWithBlock;

	}
}

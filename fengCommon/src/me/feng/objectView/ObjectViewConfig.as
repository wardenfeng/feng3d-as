package me.feng.objectView
{
	import flash.utils.Dictionary;

	import me.feng.objectView.base.view.DefaultBaseObjectView;
	import me.feng.objectView.base.view.DefaultObjectAttributeView;
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

		/**
		 * 默认对象属性界面
		 */
		public static var objectAttributeView:Class = DefaultObjectAttributeView;

		/**
		 * 自定义对象界面类定义字典（key:自定义类名称,value:界面类定义）
		 */
		public static var customObjectViewClassDic:Dictionary = new Dictionary();

		/**
		 * 自定义对象属性界面类定义字典（key:类名称+属性名,value:属性界面类定义）
		 */
		public static var customObjectAttributeViewClassDic:Dictionary = new Dictionary();

		/**
		 * 指定属性类型界面类定义字典（key:属性类名称,value:属性界面类定义）
		 */
		public static var attributeViewClassByType:Dictionary = new Dictionary();
	}
}

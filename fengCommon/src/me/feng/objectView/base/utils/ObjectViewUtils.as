package me.feng.objectView.base.utils
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	import avmplus.getQualifiedClassName;

	import me.feng.objectView.base.IObjectView;
	import me.feng.objectView.base.view.DefaultBaseObjectView;
	import me.feng.objectView.block.view.DefaultObjectViewWithBlock;
	import me.feng.utils.ClassUtils;

	/**
	 * 对象界面工具
	 * @author feng 2016-3-23
	 */
	public class ObjectViewUtils
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
		 * 自定义对象界面类定义字典（key:自定义类名称,value:界面类定义）
		 */
		public var customObjectViewClassDic:Dictionary = new Dictionary();

		/**
		 * 设置自定义对象界面类定义
		 * @param object				指定对象类型
		 * @param viewClass				自定义对象界面类定义（该类必须是实现IObjectView接口并且是DisplayObject的子类）
		 */
		public function setCustomObjectViewClass(object:Object, viewClass:Class):void
		{
			var className:String = getQualifiedClassName(object);
			customObjectViewClassDic[className] = viewClass;
		}

		/**
		 * 获取对象界面
		 * @param object	用于生成界面的对象
		 */
		public function getObjectView(object:Object):DisplayObject
		{
			var viewClass:Class = getObjectViewClass(object);
			var view:DisplayObject = new viewClass();
			IObjectView(view).data = object;
			return view;
		}

		/**
		 * 获取对象界面类定义
		 * @param object		用于生成界面的对象
		 * @return				对象界面类定义
		 */
		private function getObjectViewClass(object:Object):Class
		{
			//获取自定义类型界面类定义
			var viewClass:Class = getCustomObjectViewClass(object);
			if (viewClass != null)
				return viewClass;

			//返回基础类型界面类定义
			var isBaseType:Boolean = ClassUtils.isBaseType(object);
			if (isBaseType)
				return baseObjectViewClass;

			//返回默认类型界面类定义
			return objectViewClass;
		}

		/**
		 * 获取自定义对象界面类
		 * @param object		用于生成界面的对象
		 * @return 				自定义对象界面类定义
		 */
		private function getCustomObjectViewClass(object:Object):Class
		{
			var className:String = getQualifiedClassName(object);
			var viewClass:Class = customObjectViewClassDic[className];
			return viewClass;
		}
	}
}

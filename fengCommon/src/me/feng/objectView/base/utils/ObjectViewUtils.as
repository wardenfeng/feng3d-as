package me.feng.objectView.base.utils
{
	import flash.display.DisplayObject;

	import me.feng.objectView.base.IObjectView;
	import me.feng.objectView.configs.ObjectViewClassConfig;
	import me.feng.objectView.configs.ObjectViewConfigVO;
	import me.feng.utils.ClassUtils;

	/**
	 * 对象界面工具
	 * @author feng 2016-3-23
	 */
	public class ObjectViewUtils
	{
		/**
		 * ObjectView总配置数据
		 */
		private var objectViewConfigVO:ObjectViewConfigVO;

		/**
		 * 构建
		 */
		public function ObjectViewUtils(objectViewConfigVO:ObjectViewConfigVO)
		{
			this.objectViewConfigVO = objectViewConfigVO;
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
				return objectViewConfigVO.defaultBaseObjectViewClass;

			//返回默认类型界面类定义
			return objectViewConfigVO.defaultObjectViewClass;
		}

		/**
		 * 获取自定义对象界面类
		 * @param object		用于生成界面的对象
		 * @return 				自定义对象界面类定义
		 */
		private function getCustomObjectViewClass(object:Object):Class
		{
			var objectViewClassConfig:ObjectViewClassConfig = objectViewConfigVO.getClassConfig(object);
			return objectViewClassConfig.customObjectViewClass;
		}
	}
}

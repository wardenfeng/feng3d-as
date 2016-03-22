package me.feng.objectView.base
{
	import me.feng.objectView.base.data.ObjectAttributeInfo;

	/**
	 * 对象属性界面接口
	 * @author feng 2016-3-10
	 */
	public interface IObjectAttributeView
	{
		/**
		 * 设置对象属性信息
		 * @param value
		 */
		function set objectAttributeInfo(value:ObjectAttributeInfo):void;
	}
}

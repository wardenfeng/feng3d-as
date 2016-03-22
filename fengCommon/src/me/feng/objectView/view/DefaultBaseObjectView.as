package me.feng.objectView.view
{
	import flash.text.TextField;
	import me.feng.objectView.IObjectView;


	/**
	 * 默认基础对象界面
	 * @author feng 2016-3-11
	 */
	public class DefaultBaseObjectView extends TextField implements IObjectView
	{
		public function DefaultBaseObjectView()
		{
			super();
		}

		public function set data(value:Object):void
		{
			text = String(value);
		}
	}
}

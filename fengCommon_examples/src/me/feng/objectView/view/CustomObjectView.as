package me.feng.objectView.view
{
	import flash.display.Shape;

	import me.feng.objectView.base.IObjectView;

	/**
	 *
	 * @author feng 2016-3-23
	 */
	public class CustomObjectView extends Shape implements IObjectView
	{
		public function set data(value:Object):void
		{
			graphics.clear();
			graphics.beginFill(0xffff00);
			graphics.drawRect(0, 0, 100, 40);
			graphics.endFill();
		}
	}
}

package me.feng.objectView.view
{
	import flash.display.Shape;

	import me.feng.objectView.base.IObjectAttributeView;
	import me.feng.objectView.base.data.ObjectAttributeInfo;

	/**
	 *
	 * @author feng 2016-3-23
	 */
	public class CustomAttrView extends Shape implements IObjectAttributeView
	{
		public function set objectAttributeInfo(value:ObjectAttributeInfo):void
		{
			graphics.clear();
			graphics.beginFill(0xff0000);
			graphics.drawCircle(50, 50, 50);
			graphics.endFill();
		}
	}
}

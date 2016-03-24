package me.feng.objectView.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;

	import me.feng.objectView.base.IObjectAttributeView;
	import me.feng.objectView.base.data.ObjectAttributeInfo;

	/**
	 * 自定义属性界面
	 * @author feng 2016-3-23
	 */
	public class CustomAttrView extends Sprite implements IObjectAttributeView
	{
		public function set objectAttributeInfo(value:ObjectAttributeInfo):void
		{
			var label:TextField
			label = new TextField();
			label.text = "自定义属性界面_" + value.name;
			label.textColor = 0xffff00;
			label.width = 100;
			label.wordWrap = true;

			var bitmap:Bitmap = new Bitmap(new BitmapData(100, 50, false, 0));
			bitmap.bitmapData.draw(label);
			addChild(bitmap);
		}
	}
}

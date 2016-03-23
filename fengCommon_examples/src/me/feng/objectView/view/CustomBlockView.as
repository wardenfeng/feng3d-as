package me.feng.objectView.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;

	import me.feng.objectView.block.IObjectAttributeBlockView;
	import me.feng.objectView.block.data.ObjectAttributeBlock;

	/**
	 * 自定义块界面
	 * @author feng 2016-3-23
	 */
	public class CustomBlockView extends Sprite implements IObjectAttributeBlockView
	{
		public function set objectAttributeBlock(value:ObjectAttributeBlock):void
		{
			var label:TextField
			label = new TextField();
			label.text = "自定义块界面_(blockName:" + value.blockName + ")";
			label.textColor = 0xff00ff;
			label.width = 100;
			label.wordWrap = true;

			var bitmap:Bitmap = new Bitmap(new BitmapData(100, 50, false, 0));
			bitmap.bitmapData.draw(label);
			addChild(bitmap);
		}
	}
}

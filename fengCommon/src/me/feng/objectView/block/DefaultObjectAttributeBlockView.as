package me.feng.objectView.block
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;

	import me.feng.objectView.ObjectView;
	import me.feng.objectView.base.data.ObjectAttributeInfo;

	/**
	 * 默认对象属性块界面
	 * @author feng 2016-3-22
	 */
	public class DefaultObjectAttributeBlockView extends Sprite implements IObjectAttributeBlockView
	{

		/**
		 * @inheritDoc
		 */
		public function set objectAttributeBlock(value:ObjectAttributeBlock):void
		{
			var blockTitle:TextField = new TextField();
			//			label.height = 50;
			blockTitle.width = 100;
			blockTitle.height = 20;
			blockTitle.textColor = 0xff0000;
			blockTitle.text = value.blockName;
			addChild(blockTitle);

			var h:Number = blockTitle.x + blockTitle.height;
			var objectAttributeInfos:Vector.<ObjectAttributeInfo> = value.itemList;
			for (var i:int = 0; i < objectAttributeInfos.length; i++)
			{
				var displayObject:DisplayObject = ObjectView.getObjectAttributeView(objectAttributeInfos[i]);
				displayObject.y = h;
				addChild(displayObject);
				h += displayObject.height + 2;
			}
			graphics.clear();
			graphics.beginFill(0x666666);
			graphics.drawRect(0, 0, 200, h);
			graphics.endFill();
		}
	}
}

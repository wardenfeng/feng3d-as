package me.feng.objectView.block.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import me.feng.objectView.ObjectView;
	import me.feng.objectView.base.IObjectView;
	import me.feng.objectView.block.data.ObjectAttributeBlock;

	/**
	 * 默认使用块的对象界面
	 * @author feng 2016-3-22
	 */
	public class DefaultObjectViewWithBlock extends Sprite implements IObjectView
	{
		/**
		 * 对象界面数据
		 */
		public function set data(value:Object):void
		{
			var h:Number = 0;

			var objectAttributeBlocks:Vector.<ObjectAttributeBlock> = ObjectView.getObjectAttributeBlocks(value);

			for (var i:int = 0; i < objectAttributeBlocks.length; i++)
			{
				var displayObject:DisplayObject = ObjectView.getObjectAttributeBlockView(objectAttributeBlocks[i]);
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

package me.feng.objectView
{
	import com.bit101.components.VBox;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;


	/**
	 *
	 * @author feng 2016-3-11
	 */
	public class DefaultObjectView extends VBox implements IObjectView
	{
		public function DefaultObjectView(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		public function set data(value:Object):void
		{
			var objectAttributeInfos:Vector.<ObjectAttributeInfo> = ObjectAttributeInfo.getObjectAttributeInfos(value);
			for (var i:int = 0; i < objectAttributeInfos.length; i++)
			{
				var displayObject:DisplayObject = ObjectView.getObjectAttributeView(objectAttributeInfos[i]);
				addChild(displayObject);
			}
		}
	}
}

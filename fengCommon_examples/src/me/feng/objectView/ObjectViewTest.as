package me.feng.objectView
{
	import com.bit101.components.HBox;

	import flash.display.DisplayObjectContainer;

	//
	//
	// @author feng 2016-3-10
	//
	[SWF(width = "800", height = "600")]
	public class ObjectViewTest extends TestBase
	{
		public function init():void
		{
			var box:DisplayObjectContainer = new HBox();

			var a:ObjectA = new ObjectA();
			a.da = 2;
			a.db = "```";
			box.addChild(ObjectView.getObjectView(a));

			ObjectView.setCustomObjectAttributeViewClass(Object, "custom", CustomAttrView);
			box.addChild(ObjectView.getObjectView( //
				{aaaaaaaaaaaaaaaaa: "asfddddddddddddddddddddddddddddddddd", b: "bnm,", c: 1, d: false, custom: "", obj: {a: 1}} //
				));

			ObjectView.setCustomObjectViewClass(int, customObjectView);
			box.addChild(ObjectView.getObjectView(5));

			addChild(box);
		}
	}
}
import flash.display.Shape;

import me.feng.objectView.IObjectAttributeView;
import me.feng.objectView.IObjectView;
import me.feng.objectView.ObjectAttributeInfo;

class CustomAttrView extends Shape implements IObjectAttributeView
{
	public function set objectAttributeInfo(value:ObjectAttributeInfo):void
	{
		graphics.clear();
		graphics.beginFill(0xff0000);
		graphics.drawCircle(50, 50, 50);
		graphics.endFill();
	}
}

class customObjectView extends Shape implements IObjectView
{
	public function set data(value:Object):void
	{
		graphics.clear();
		graphics.beginFill(0xffff00);
		graphics.drawRect(0, 0, 100, 40);
		graphics.endFill();
	}
}

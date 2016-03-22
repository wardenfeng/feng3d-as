package me.feng.objectView
{
	import com.bit101.components.HBox;

	import flash.display.DisplayObject;
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

			ObjectView.setAttributeViewClassByType(Boolean, BooleanAttrView);

			var a:ObjectA = new ObjectA();
			a.boo = true;
			a.da = 2;
			a.db = "```";
			box.addChild(ObjectView.getObjectView(a));

			ObjectView.setCustomObjectAttributeViewClass(Object, "custom", CustomAttrView);
			var objView:DisplayObject = ObjectView.getObjectView( //
				{aaaaaaaaaaaaaaaaa: "asfddddddddddddddddddddddddddddddddd", b: "bnm,", c: 1, d: false, custom: "", obj: {a: 1}} //
				);
			objView.metaData = {a: 1};
			box.addChild(objView);

			ObjectView.setCustomObjectViewClass(int, customObjectView);
			box.addChild(ObjectView.getObjectView(5));

			addChild(box);
		}
	}
}
import com.bit101.components.CheckBox;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;

import me.feng.objectView.base.IObjectAttributeView;
import me.feng.objectView.base.IObjectView;
import me.feng.objectView.base.data.ObjectAttributeInfo;

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

class BooleanAttrView extends Sprite implements IObjectAttributeView
{
	private var data:ObjectAttributeInfo;
	private var label:TextField;
	private var checkBox:CheckBox;

	public function BooleanAttrView()
	{
		label = new TextField();
		//			label.height = 50;
		label.width = 100;
		label.height = 20;
		addChild(label);

		checkBox = new CheckBox();
		checkBox.x = 100;
		checkBox.y = 5;
		checkBox.addEventListener(Event.CHANGE, onChange);
		addChild(checkBox);

		graphics.beginFill(0x999999);
		graphics.drawRect(0, 0, 200, 24);
	}

	protected function onChange(event:Event):void
	{
		data.owner[data.name] = checkBox.selected;
	}

	public function set objectAttributeInfo(value:ObjectAttributeInfo):void
	{
		data = value;

		label.text = data.name;
		checkBox.selected = data.owner[data.name];
	}

}



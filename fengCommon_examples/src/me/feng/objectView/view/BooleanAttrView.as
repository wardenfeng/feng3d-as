package me.feng.objectView.view
{
	import com.bit101.components.CheckBox;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	import me.feng.objectView.base.IObjectAttributeView;
	import me.feng.objectView.base.data.ObjectAttributeInfo;

	/**
	 * Boolean类型界面
	 * @author feng 2016-3-23
	 */
	public class BooleanAttrView extends Sprite implements IObjectAttributeView
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
}

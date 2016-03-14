package me.feng.objectView
{
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.getDefinitionByName;

	/**
	 * 默认对象属性界面
	 * @author feng 2016-3-10
	 */
	public class DefaultObjectAttributeView extends Sprite implements IObjectAttributeView
	{
		private var _objectAttributeInfo:ObjectAttributeInfo;
		private var isInit:Boolean;
		private var label:TextField;
		private var text:TextField;

		/**
		 * 初始化
		 */
		private function init():void
		{
			if (isInit)
				return;
			isInit = true;

			label = new TextField();
			//			label.height = 50;
			label.width = 100;
			label.height = 20;
			addChild(label);

			text = new TextField();
			text.border = true;
			text.x = 100;
			text.height = 20;
			text.width = 100;
			text.type = TextFieldType.INPUT;
			text.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			text.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			addChild(text);
			graphics.beginFill(0x999999);
			graphics.drawRect(0, 0, 200, 24);
		}

		private var textTemp:String;

		protected function onFocusOut(event:FocusEvent):void
		{
			if (textTemp != text.text)
			{
				var cls:Class = getDefinitionByName(_objectAttributeInfo.type) as Class;
				_objectAttributeInfo.owner[_objectAttributeInfo.name] = cls(text.text);
				if (cls == Boolean && (text.text == "0" || text.text == "false"))
				{
					_objectAttributeInfo.owner[_objectAttributeInfo.name] = false;
				}
				objectAttributeInfo = objectAttributeInfo;
			}

			textTemp = null;
		}

		protected function onFocusIn(event:FocusEvent):void
		{
			textTemp = text.text;
		}

		/**
		 * 对象属性信息
		 */
		public function get objectAttributeInfo():ObjectAttributeInfo
		{
			return _objectAttributeInfo;
		}

		public function set objectAttributeInfo(value:ObjectAttributeInfo):void
		{
			init();

			label.text = value.name + ":";

			var attributeValue:Object = value.owner[value.name];
			text.text = String(attributeValue);

			_objectAttributeInfo = value;
		}

	}
}

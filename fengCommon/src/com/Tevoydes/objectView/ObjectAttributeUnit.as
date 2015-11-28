package com.Tevoydes.objectView
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.Text;

	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * 模型的单条信息
	 * @author Tevoydes 2015-10-24
	 */
	public class ObjectAttributeUnit
	{
		/**名称*/
		private var name:String;
		/**类型*/
		private var type:String;
		/**属性*/
		private var value:*;
		/**完全限定名*/
		private var qualifiedName:String;
		/**组件对应属性的字典*/
		private static var attrDic:Dictionary;

		/**
		 *构建
		 *
		 */
		public function ObjectAttributeUnit()
		{
			if (attrDic == null)
			{
				attrDic = new Dictionary;
			}
		}

		/**
		 *创建单元数据
		 *
		 */
		public function create(_obj:*, _name:String):void
		{
			name = _name;
			type = "";
		}

		/**
		 *获取单元数据
		 * @param _obj
		 * @return
		 *
		 */
		public function getUnitData(_obj:Object):HBox
		{
			value = _obj[name];

			var hBox:HBox = new HBox;
			hBox.width = 200;
			var label:Label = new Label;
			label.text = name;
//			label.height = 50;
			label.width = 100;
			label.autoSize = false;
			hBox.addChildAt(label, hBox.numChildren);
			switch (type)
			{
				case "CheckBox":
					var checkBox:CheckBox = new CheckBox;
					break;
				case "ComboBox":
					var comboBox:ComboBox = new ComboBox;
					break;
				default:
					var text:Text = new Text;
					text.text = String(value);
					text.height = 20;
					text.width = 100;
					attrDic[text] = new Object;
					attrDic[text].obj = _obj
					attrDic[text].attr = name;
					text.addEventListener(Event.CHANGE, onChange);
					hBox.addChildAt(text, hBox.numChildren);
					break;
			}

			return hBox;
		}

		/**
		 *组件中值发生改变时，改变对应值
		 * @param event
		 *
		 */
		private function onChange(event:Event):void
		{
			var text:Text = event.currentTarget as Text;
			var obj:Object = attrDic[text].obj;
			var attr:* = attrDic[text].attr;
			obj[attr] = text.text;
		}

		/**
		 *清除字典
		 *
		 */
		public static function clearDic():void
		{
			if (attrDic != null)
			{
				for (var temp:* in attrDic)
				{
					attrDic[temp] = null
				}
				attrDic = null;
			}
		}
	}
}

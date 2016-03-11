package me.feng.objectView
{
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.Text;

	import flash.display.DisplayObjectContainer;

	/**
	 * 默认对象属性界面
	 * @author feng 2016-3-10
	 */
	public class DefaultObjectAttributeView extends HBox implements IObjectAttributeView
	{
		private var _objectAttributeInfo:ObjectAttributeInfo;
		private var isInit:Boolean;
		private var label:Label;
		private var text:Text;

		/**
		 * 创建默认对象属性界面
		 * @param parent
		 * @param xpos
		 * @param ypos
		 *
		 */
		public function DefaultObjectAttributeView(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		/**
		 * 初始化
		 */
		private function init():void
		{
			if (isInit)
				return;
			isInit = true;

			width = 200;
			label = new Label;
			//			label.height = 50;
			label.width = 100;
			label.autoSize = false;
			addChild(label);

			text = new Text;
			text.height = 20;
			text.width = 100;
			addChild(text);
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

			label.text = value.name;

			var attributeValue:Object = value.owner[value.name];
			text.text = String(attributeValue);

			_objectAttributeInfo = value;
		}

	}
}

package com.Tevoydes
{

	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import me.feng.objectView.ObjectView;

	/**
	 * ObjectView的测试范例
	 * @author Tevoydes 2015-11-10
	 */
	[SWF(width = "800", height = "600")]
	public class TestObjectView extends TestBase
	{
		/**ObjectView所使用的对象*/
		public static var obj:Object;

		public function TestObjectView()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}

		public function init():void
		{
			var data:Object = new Object;
			obj = new Object;
			obj.aaaaaaaaaaaaaaaaa = "asfddddddddddddddddddddddddddddddddd";
			obj.b = "bnm,";
			obj.c = 1;
			obj.d = false;
			data.object = obj;

			var displayObject:DisplayObject = ObjectView.getObjectView(obj);
			addChild(displayObject);
		}
	}
}

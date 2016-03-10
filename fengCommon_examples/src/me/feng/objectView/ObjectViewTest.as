package me.feng.objectView
{
	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;

	//
	//
	// @author feng 2016-3-10
	//
	[SWF(width = "800", height = "600")]
	public class ObjectViewTest extends TestBase
	{

		public function init():void
		{
			var obj:Object = new Object;
			obj = new Object;
			obj.aaaaaaaaaaaaaaaaa = "asfddddddddddddddddddddddddddddddddd";
			obj.b = "bnm,";
			obj.c = 1;
			obj.d = false;

			var displayObject:DisplayObject = ObjectView.getObjectView(obj);
			addChild(displayObject);

			var objectAttributeInfos:Vector.<ObjectAttributeInfo> = ObjectAttributeInfo.getObjectAttributeInfos(obj);
			trace(JSON.stringify(objectAttributeInfos));

			var className:String = getQualifiedClassName(null);
			trace(className);
		}
	}
}

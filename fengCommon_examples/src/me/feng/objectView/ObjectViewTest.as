package me.feng.objectView
{
	import com.bit101.components.HBox;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import me.feng.objectView.data.ObjectA;
	import me.feng.objectView.view.BooleanAttrView;
	import me.feng.objectView.view.CustomAttrView;
	import me.feng.objectView.view.customObjectView;

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

			ObjectViewConfig.setAttributeViewClassByType(Boolean, BooleanAttrView);

			var a:ObjectA = new ObjectA();
			a.boo = true;
			a.da = 2;
			a.db = "```";
			box.addChild(ObjectView.getObjectView(a));

			ObjectViewConfig.setCustomObjectAttributeViewClass(Object, "custom", CustomAttrView);
			var objView:DisplayObject = ObjectView.getObjectView( //
				{aaaaaaaaaaaaaaaaa: "asfddddddddddddddddddddddddddddddddd", b: "bnm,", c: 1, d: false, custom: "", obj: {a: 1}} //
				);
			objView.metaData = {a: 1};
			box.addChild(objView);

			ObjectViewConfig.setCustomObjectViewClass(int, customObjectView);
			box.addChild(ObjectView.getObjectView(5));

			addChild(box);
		}
	}
}








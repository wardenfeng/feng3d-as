package me.feng.objectView
{
	import com.bit101.components.HBox;

	import flash.display.DisplayObjectContainer;

	//
	//
	// @author feng 2016-3-23
	//
	[SWF(width = "800", height = "600")]
	public class ObjectViewWithBlockTest extends TestBase
	{
		public function init():void
		{
			initBlockConfig()

			var box:DisplayObjectContainer = new HBox();

			var a:ObjectA = new ObjectA();
			a.boo = true;
			a.da = 2;
			a.db = "```";
			box.addChild(ObjectView.getObjectView(a));
			addChild(box);
		}

		private function initBlockConfig():void
		{

		}
	}
}



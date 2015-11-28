package com.Tevoydes
{

	import com.Tevoydes.objectView.ObjectViewEvent;
	import com.Tevoydes.objectView.ObjectViewManager;

	import me.feng.core.GlobalDispatcher;

	/**
	 * ObjectView的测试范例
	 * @author Tevoydes 2015-11-10
	 */
	public class TestObjectView extends TestBase
	{
		/**ObjectView所使用的对象*/
		public static var obj:Object;

		public function TestObjectView()
		{

		}


		public function init():void
		{
			var dispatcher:GlobalDispatcher = GlobalDispatcher.instance;
			ObjectViewManager.init(this.stage);
			var data:Object = new Object;
			obj = new Object;
			obj.aaaaaaaaaaaaaaaaa = "asfddddddddddddddddddddddddddddddddd";
			obj.b = "bnm,";
			obj.c = 1;
			obj.d = false;
			data.object = obj;
			dispatcher.dispatchEvent(new ObjectViewEvent(ObjectViewEvent.SHOW_OBJECTVIEW, data));
		}
	}
}

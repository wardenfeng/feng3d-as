package
{
	import com.bit101.components.List;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getQualifiedClassName;

	import me.feng.enum.EnumTest;
	import me.feng.error.AbstractClassErrorTest;
	import me.feng.events.CustomEventContentAssistTest;
	import me.feng.events.EventBubblesTest;
	import me.feng.events.EventBubblesTest2;
	import me.feng.events.FEventDispatcherTest;
	import me.feng.events.IFEventDispatcherTest;
	import me.feng.task.TaskListTest;

	/**
	 * feng公共类库实例
	 * @author feng 2015-5-8
	 */
	[SWF(width = "800", height = "600")]
	public class FengCommonExamples extends Sprite
	{
		private var testClassList:Array = [ //
			AbstractClassErrorTest, //
			TaskListTest, //
			EnumTest, //
			CustomEventContentAssistTest, //
			EventBubblesTest, //
			EventBubblesTest2, //
			FEventDispatcherTest, //
			IFEventDispatcherTest, //
			];
		private var testInstanceList:Array = [];
		private var index:int = 0;

		public function FengCommonExamples()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			stage && init();
		}

		private function init(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			logTf = new TextField();
			logTf.x = 100;
			logTf.border = true;
			logTf.multiline = true;
			logTf.wordWrap = true;
			logTf.autoSize = TextFieldAutoSize.LEFT;
			logTf.width = 600;
			logTf.height = 400;
			addChild(logTf);

			var list:List = new List();
			addChild(list);
			for (var i:int = 0; i < testClassList.length; i++)
			{
				list.addItem({label: getQualifiedClassName(testClassList[i]).split("::").pop()});
			}
			list.addEventListener(MouseEvent.CLICK, function(event:Event):void
			{
				event.stopPropagation();
				showTest(list.selectedIndex);
			});
			showTest(0);
		}

		private function showTest(value:int):void
		{
			logTf.text = "";
			var currentInstance:Sprite = testInstanceList[index];
			currentInstance && currentInstance.parent && currentInstance.parent.removeChild(currentInstance);

			currentInstance = testInstanceList[index = value] ||= new (testClassList[value = ((value + testClassList.length) % testClassList.length)])();
			addChild(currentInstance);
		}

		private static var logTf:TextField;

		public static function log(... arg):void
		{
			trace("trace", arg.join(" "));
			logTf && logTf.appendText(arg.join(" ") + "\n");
		}
	}
}

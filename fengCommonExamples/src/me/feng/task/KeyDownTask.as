package me.feng.task
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	//按键任务
	//@author warden_feng 2015-6-17
	//
	public class KeyDownTask extends TaskItem
	{
		private var stage:Stage;
		public var charValue:String;
		public var keyCode:int;

		public function KeyDownTask(stage:Stage, charValue:String)
		{
			super();
			this.stage = stage;
			this.charValue = charValue;
			this.keyCode = charValue.charCodeAt();
		}

		override public function execute(params:* = null):void
		{
			super.execute(params);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		private function onKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == keyCode)
			{
				doComplete();
			}
		}

		override protected function doComplete():void
		{
			super.doComplete();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		override public function destroy():void
		{
			super.destroy();
			if (stage != null)
			{
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				stage = null;
			}
		}
	}
}

package
{
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 测试基类
	 * @author feng 2015-5-8
	 */
	public class TestBase extends Sprite
	{
		private const initFuncName:String = "init";
		private const destroyFuncName:String = "destroy";

		/**
		 * 创建测试基类
		 */
		public function TestBase()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			stage && onAddToStage();
		}

		/**
		 * 处理添加到舞台
		 */
		protected function onAddToStage(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromeStage);

			if (this.hasOwnProperty(initFuncName))
			{
				this[initFuncName]();
			}
		}

		/**
		 * 处理移除舞台事件
		 */
		protected function onRemoveFromeStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromeStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);

			if (this.hasOwnProperty(destroyFuncName))
			{
				this[destroyFuncName]();
			}
		}

		/**
		 * 覆盖Flash自带的trace
		 * @param arg
		 */
		protected function trace(... arg):void
		{
			FengCommonExamples.log.apply(null, arg);
		}
	}
}

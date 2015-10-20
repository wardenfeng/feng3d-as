package me.feng.task
{
	import me.feng.events.FEventDispatcher;
	import me.feng.events.TaskEvent;

	/**
	 * 完成任务时触发
	 * @eventType me.feng.events.TaskEvent
	 */
	[Event(name = "completed", type = "me.feng.events.TaskEvent")]

	/**
	 * 任务
	 * @author feng 2015-5-27
	 */
	public class Task extends FEventDispatcher
	{
		/** 任务状态 */
		protected var _state:int = TaskState.STATE_INIT;

		/**
		 * 任务状态
		 */
		public function get state():int
		{
			return _state;
		}

		/**
		 * 创建一个任务单元数据
		 */
		public function Task()
		{
			_state = TaskState.STATE_INIT;
		}

		/**
		 * 执行任务
		 * @param params	执行参数
		 */
		public function execute(params:* = null):void
		{
			_state = TaskState.STATE_EXECUTING;

		}

		/**
		 * 执行完成事件
		 */
		protected function doComplete():void
		{
			_state = TaskState.STATE_COMPLETED;

			dispatchEvent(new TaskEvent(TaskEvent.COMPLETED));
		}

		/**
		 * 销毁
		 */
		public function destroy():void
		{

		}
	}
}

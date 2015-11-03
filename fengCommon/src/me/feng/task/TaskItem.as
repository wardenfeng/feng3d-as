package me.feng.task
{
	import me.feng.events.FEventDispatcher;

	/**
	 * 完成任务时触发
	 * @eventType me.feng.events.TaskEvent
	 */
	[Event(name = "completed", type = "me.feng.task.TaskEvent")]

	/**
	 * 任务
	 * @author feng 2015-5-27
	 */
	public class TaskItem extends FEventDispatcher
	{
		/** 任务状态 */
		protected var _state:int = TaskStateType.STATE_INIT;

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
		public function TaskItem()
		{
			_state = TaskStateType.STATE_INIT;
		}

		/**
		 * 执行任务
		 * @param params	执行参数
		 */
		public function execute(params:* = null):void
		{
			_state = TaskStateType.STATE_EXECUTING;

		}

		/**
		 * 执行完成事件
		 */
		protected function doComplete():void
		{
			_state = TaskStateType.STATE_COMPLETED;

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


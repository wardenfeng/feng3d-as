package me.feng.task
{
	import me.feng.task.type.TaskQueue;

	//测试任务队列
	//鼠标分别单击与双击完成任务
	//@author feng 2015-6-17
	public class TaskQueueTest extends TestBase
	{
		public function init():void
		{
			trace("这里有分别按下A、B两个按键子任务，完成之后即可完成整个任务。");
			trace("该任务为任务队列，必须先完成A任务才能执行B任务！");

			var keyTask:String = "AB";

			//创建任务列表
			var taskQueue:TaskQueue = new TaskQueue();
			taskQueue.addEventListener(TaskEvent.COMPLETED, onCompleted);
			taskQueue.addEventListener(TaskEvent.COMPLETEDITEM, onCompletedItem);
			for (var i:int = 0; i < keyTask.length; i++)
			{
				//添加 单击任务
				taskQueue.addItem(new KeyDownTask(stage, keyTask.charAt(i)));
			}
			//等待用户单击 和 双击 完成任务
			taskQueue.execute();
		}

		protected function onCompleted(event:TaskEvent):void
		{
			trace("完成总任务");

			var taskQueue:TaskQueue = event.currentTarget as TaskQueue;
			taskQueue.removeEventListener(TaskEvent.COMPLETED, onCompleted);
			taskQueue.removeEventListener(TaskEvent.COMPLETEDITEM, onCompletedItem);
			taskQueue.destroy();
		}

		protected function onCompletedItem(event:TaskEvent):void
		{
			var taskItem:KeyDownTask = event.data;

			trace("完成按下" + taskItem.charValue + "键子任务");
		}

		public function destroy():void
		{
		}
	}
}

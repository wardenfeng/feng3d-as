package me.feng.task
{
	import me.feng.core.GlobalDispatcher;
	import me.feng.events.task.TaskModuleEvent;
	import me.feng.events.task.TaskModuleEventDispatchTaskData;
	import me.feng.task.type.TaskCollectionType;

	//
	// @author feng 2015-10-29
	public class TaskModuleTest extends TestBase
	{
		public function init():void
		{
			Task.init();

			//注册列表任务
//			GlobalDispatcher.instance.dispatchEvent(new TaskModuleEvent(TaskModuleEvent.REGISTER_TASKCOLLECTIONTYPE, new TaskModuleEventRegisterData(TaskCollectionType.QUEUE, TaskQueue)));

			trace("这里有分别按下A、B两个按键子任务，完成之后即可完成整个任务。");
			trace("该任务为任务队列，必须先完成A任务才能执行B任务！");

			var keyTask:String = "AB";
			var taskList:Vector.<TaskItem> = new Vector.<TaskItem>();
			for (var i:int = 0; i < keyTask.length; i++)
			{
				//添加 单击任务
				taskList.push(new KeyDownTask(stage, keyTask.charAt(i)));
			}

			var taskData:TaskModuleEventDispatchTaskData = new TaskModuleEventDispatchTaskData(taskList, TaskCollectionType.QUEUE);
			taskData.addEventListener(TaskEvent.COMPLETEDITEM, onCompletedItem);
			taskData.addEventListener(TaskEvent.COMPLETED, onCompleted);

			GlobalDispatcher.instance.dispatchEvent(new TaskModuleEvent(TaskModuleEvent.DISPATCH_TASK, taskData));
		}

		protected function onCompletedItem(event:TaskEvent):void
		{
			var taskItem:KeyDownTask = event.data;

			trace("完成按下" + taskItem.charValue + "键子任务");
		}

		protected function onCompleted(event:TaskEvent):void
		{
			trace("完成总任务");

			var taskData:TaskModuleEventDispatchTaskData = event.currentTarget as TaskModuleEventDispatchTaskData;
			taskData.removeEventListener(TaskEvent.COMPLETEDITEM, onCompletedItem);
			taskData.removeEventListener(TaskEvent.COMPLETED, onCompleted);
		}

		public function destroy():void
		{

		}
	}
}

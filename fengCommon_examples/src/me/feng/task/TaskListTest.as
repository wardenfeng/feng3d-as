package me.feng.task
{
	import me.feng.events.TaskEvent;

	//测试任务列表
	//鼠标分别单击与双击完成任务
	//@author warden_feng 2015-3-9
	public class TaskListTest extends TestBase
	{
		private var taskList:TaskList;

		public function init():void
		{
			trace("这里有分别按下A、B两个按键子任务，完成之后即可完成整个任务。");
			trace("该任务为任务列表，两个任务独立进行，可以以任意顺序执行AB两个任务！");

			var keyTask:String = "AB";

			//创建任务列表
			taskList = new TaskList();
			taskList.addEventListener(TaskEvent.COMPLETED, onCompleted);
			taskList.addEventListener(TaskEvent.COMPLETEDITEM, onCompletedItem);
			for (var i:int = 0; i < keyTask.length; i++)
			{
				//添加 单击任务
				taskList.addItem(new KeyDownTask(stage, keyTask.charAt(i)));
			}
			//等待用户单击 和 双击 完成任务
			taskList.execute();
		}

		protected function onCompleted(event:TaskEvent):void
		{
			trace("完成总任务");
		}

		protected function onCompletedItem(event:TaskEvent):void
		{
			var taskItem:KeyDownTask = event.data;

			trace("完成按下" + taskItem.charValue + "键子任务");
		}

		public function destroy():void
		{
			//移除所有子任务
			taskList.removeEventListener(TaskEvent.COMPLETED, onCompleted);
			taskList.removeEventListener(TaskEvent.COMPLETEDITEM, onCompletedItem);
			taskList.destroy();
			taskList = null;
		}
	}
}

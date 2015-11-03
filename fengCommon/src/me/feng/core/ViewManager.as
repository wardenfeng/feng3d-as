package me.feng.core
{
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * 界面管理器
	 * <p>为界面模块搭建框架</p>
	 * @author feng
	 */
	public class ViewManager extends FModuleManager
	{
		/**
		 * 主界面
		 */
		protected var mainUI:MovieClip;

		/**
		 * 创建一个界面管理器
		 */
		public function ViewManager()
		{

		}

		/**
		 * 显示界面
		 */
		protected function show():void
		{

		}

		/**
		 * 更新界面
		 */
		protected function updateView():void
		{

		}

		/**
		 * 关闭界面
		 */
		protected function close():void
		{

		}

		/**
		 * 添加侦听修改界面表现的事件等
		 */
		protected function onAddToStage(event:Event):void
		{

		}

		/**
		 * 移除侦听修改界面表现的事件等
		 */
		protected function onRemovedFromStage(event:Event):void
		{

		}
	}
}

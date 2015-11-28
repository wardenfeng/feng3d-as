package com.Tevoydes.objectView
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	import me.feng.core.FModuleManager;

	/**
	 * 模型界面管理类
	 * @author Tevoydes 2015-10-28
	 */
	public class ObjectViewManager extends FModuleManager
	{
		/** 模型属性界面的实例*/
		private static var myObjectView:ObjectView;
		/**此类的实例*/
		private static var instance:ObjectViewManager;

		public function ObjectViewManager()
		{
		}

		/**
		 *清理内存
		 *
		 */
		public static function clearMem():void
		{
			if (instance == null)
			{
				return;
			}
			myObjectView = null;
			instance.unRegister();
		}

		/**
		 *初始化
		 *
		 */
		public static function init(_mom:DisplayObjectContainer):void
		{
			if (instance == null)
			{
				instance = new ObjectViewManager;

			}
			instance.registerEventListener(_mom);
		}

		/**
		 *注册监听
		 *
		 */
		private function registerEventListener(_mom:DisplayObjectContainer):void
		{
			if (myObjectView == null)
			{
				myObjectView = new ObjectView(_mom);
			}
			myObjectView.addEventListener(Event.CLOSE, onClose);
			dispatcher.addEventListener(ObjectViewEvent.SHOW_OBJECTVIEW, showObject);
			dispatcher.addEventListener(ObjectViewEvent.REGISTER, register);
		}

		/**
		 *注销监听
		 *
		 */
		private function unRegister():void
		{
			myObjectView.removeEventListener(Event.CLOSE, onClose);
			dispatcher.removeEventListener(ObjectViewEvent.SHOW_OBJECTVIEW, showObject);
			dispatcher.removeEventListener(ObjectViewEvent.REGISTER, register);

		}

		/**
		 *显示界面
		 * @param event
		 *
		 */
		private function showObject(event:ObjectViewEvent):void
		{

			myObjectView.showObjectView(event.data.object);
		}

		/**
		 *注册类
		 * @param event
		 *
		 */
		private function register(event:ObjectViewEvent):void
		{
			myObjectView.register();
		}


		/**
		 *关闭界面
		 * @param event
		 *
		 */
		private function onClose(event:Event):void
		{
			myObjectView.openOrCloseView();
		}



	}
}

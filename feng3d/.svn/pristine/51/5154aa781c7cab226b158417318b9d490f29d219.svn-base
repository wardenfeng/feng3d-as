package me.feng3d.controllers
{
	import me.feng3d.entities.Entity;
	import me.feng3d.errors.AbstractMethodError;

	/**
	 * 控制器
	 * @author warden_feng 2014-10-10
	 */
	public class ControllerBase
	{
		protected var _targetObject:Entity;

		/**
		 * 创建控制器
		 * @param targetObject 被控制对象
		 */
		public function ControllerBase(targetObject:Entity = null)
		{
			this.targetObject = targetObject;
		}

		/**
		 * 被控制对象
		 */
		public function get targetObject():Entity
		{
			return _targetObject;
		}

		public function set targetObject(val:Entity):void
		{
			if (_targetObject == val)
				return;

			_targetObject = val;

			notifyUpdate();
		}

		/**
		 * 通知被控制对象更新
		 */
		protected function notifyUpdate():void
		{
			update();
		}

		/**
		 * 更新被控制对象状态
		 */
		public function update():void
		{
			throw new AbstractMethodError();
		}
	}
}

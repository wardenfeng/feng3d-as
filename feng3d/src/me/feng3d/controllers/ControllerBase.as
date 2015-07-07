package me.feng3d.controllers
{
	import me.feng.error.AbstractClassError;
	import me.feng.error.AbstractMethodError;
	import me.feng3d.arcane;
	import me.feng3d.entities.Entity;

	use namespace arcane;

	/**
	 * 控制器
	 * @author warden_feng 2014-10-10
	 */
	public class ControllerBase
	{
		protected var _autoUpdate:Boolean = true;
		protected var _targetObject:Entity;

		/**
		 * 创建控制器
		 * @param targetObject 被控制对象
		 */
		public function ControllerBase(targetObject:Entity = null)
		{
			this.targetObject = targetObject;

			AbstractClassError.check(this);
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

			if (_targetObject && _autoUpdate)
				_targetObject._controller = null;

			_targetObject = val;

			if (_targetObject && _autoUpdate)
				_targetObject._controller = this;

			notifyUpdate();
		}

		/**
		 * 通知被控制对象更新
		 */
		protected function notifyUpdate():void
		{
			update();
			//
			if (_targetObject && _targetObject.implicitPartition && _autoUpdate)
				_targetObject.implicitPartition.markForUpdate(_targetObject);
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

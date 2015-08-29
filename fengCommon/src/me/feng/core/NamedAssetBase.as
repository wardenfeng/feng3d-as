package me.feng.core
{
	import flash.utils.getQualifiedClassName;

	import me.feng.events.FEventDispatcher;

	/**
	 * 拥有名字的对象
	 * @author warden_feng 2014-5-7
	 */
	public class NamedAssetBase extends FEventDispatcher
	{
		private static var autoNamedId:int = 0;

		/**
		 * 创建一个拥有名字的对象
		 */
		public function NamedAssetBase()
		{
			super(this);
		}

		/**
		 * 名称
		 */
		override public function get name():String
		{
			if (!_name)
			{
				_name = getQualifiedClassName(this).split("::").pop() + createNamedId();
			}
			return _name;
		}

		override public function set name(value:String):void
		{
//			if (_name)
//				throw new Error(getQualifiedClassName(this) + " -- 对象已经有名称，无法更改");
			_name = value;
		}

		/**
		 * 产生唯一标识
		 */
		private static function createNamedId():int
		{
			return autoNamedId++;
		}
	}
}

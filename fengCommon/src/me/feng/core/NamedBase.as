package me.feng.core
{
	import flash.utils.getQualifiedClassName;

	/**
	 * 拥有名字的对象
	 * @author warden_feng 2014-5-7
	 */
	public class NamedBase
	{
		private static var autoNamedId:int = 0;
		private var _name:String;

		/**
		 * 创建一个拥有名字的对象
		 */
		public function NamedBase()
		{
		}

		/**
		 * 名称
		 */
		public function get name():String
		{
			if (!_name)
			{
				_name = getQualifiedClassName(this).split("::").pop() + createNamedId();
			}
			return _name;
		}

		public function set name(value:String):void
		{
			if (_name)
				throw new Error(getQualifiedClassName(this) + " -- 对象已经有名称，无法更改");
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

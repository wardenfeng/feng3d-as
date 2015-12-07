package me.feng.core
{
	import flash.utils.Dictionary;

	import me.feng.component.Component;
	import me.feng.utils.ClassUtils;

	/**
	 * 拥有名字的对象
	 * @author feng 2014-5-7
	 */
	public class NamedAsset extends Component
	{
		private static const nameDic:Dictionary = new Dictionary();

		/**
		 * 创建一个拥有名字的对象
		 */
		public function NamedAsset()
		{
			super();
		}

		/**
		 * 名称
		 */
		override public function get name():String
		{
			if (!_name)
			{
				var defaultName:String = ClassUtils.getDefaultName(this);
				_name = defaultName + int(nameDic[defaultName]);
				nameDic[defaultName] = int(nameDic[defaultName]) + 1;
			}
			return _name;
		}

		override public function set name(value:String):void
		{
//			if (_name)
//				throw new Error(getQualifiedClassName(this) + " -- 对象已经有名称，无法更改");
			_name = value;
		}

	}
}

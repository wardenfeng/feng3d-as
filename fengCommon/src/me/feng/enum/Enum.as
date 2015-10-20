package me.feng.enum
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * 枚举类
	 * <p>用于实现类似其他语言的枚举对象，该类为虚类，无法直接实例化，请使用子类</p>
	 * <p>枚举元素必须使用 public static const 定义</p>
	 * @includeExample EnumTest.as
	 * @includeExample TypeEnum.as
	 * @includeExample TypeEnum1.as
	 *
	 * @author feng 2015-5-7
	 */
	public class Enum
	{
		/**
		 * 枚举计数字典
		 */
		private static var autoIndexDic:Dictionary = new Dictionary();
		/**
		 * 枚举值
		 */
		private var value:int;
		/**
		 * 枚举类名称
		 */
		private var className:String;
		/**
		 * 枚举类短名称
		 */
		private var type:String;

		/**
		 * 无法直接实例化
		 */
		public function Enum()
		{
			className = getQualifiedClassName(this);
			type = className.split("::").pop();

			CONFIG::debug
			{
				import flash.utils.getDefinitionByName;

				//静态成员变量  运行在 类初始化 之前，此处将获取到
				var cls:Class = getDefinitionByName(className) as Class;
				if (cls != null)
				{
					throw new Error("枚举类" + className + "无法在外部初始化!");
				}
			}

			//获取枚举的值
			value = int(autoIndexDic[className]);
			autoIndexDic[className] = value + 1;
		}

		/**
		 * 转换值
		 * @see http://filimanjaro.com/blog/2012/operators-overloading-in-as3-javascript-too-%E2%80%93-workaround/
		 */
		public function valueOf():int
		{
			return this.value;
		}

		/**
		 * 输出为字符串
		 */
		public function toString():String
		{
			return type + "-" + value;
		}
	}
}

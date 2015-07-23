package me.feng3d.fagalRE
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.getQualifiedClassName;

	import me.feng3d.fagal.base.math.FagalMath;

	/**
	 * Fagal运行环境空间
	 * @author warden_feng 2015-7-23
	 */
	public dynamic class FagalRESpace extends Proxy
	{
		private var _math:FagalMath;

		/**
		 * Fagal数学运算
		 */
		private function get math():FagalMath
		{
			return _math ||= new FagalMath();
		}

		/**
		 * Fagal寄存器中心
		 */
		private function get registerCenter():FagalRegisterCenter
		{
			return FagalRegisterCenter.instance;
		}

		/**
		 * 创建Fagal运行环境空间
		 */
		public function FagalRESpace()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		override flash_proxy function getProperty(name:*):*
		{
			var attr:String = name;

			if (registerCenter.hasOwnProperty(attr))
				return registerCenter[attr];

			throw new ReferenceError("在 " + getQualifiedClassName(this) + " 上找不到属性 " + name + "，且没有默认值");
		}

		/**
		 * @inheritDoc
		 */
		override flash_proxy function callProperty(name:*, ... parameters):*
		{
			var funcName:String = String(name);
			var func:Function = math[funcName];

			return func.apply(null, parameters);
		}
	}
}

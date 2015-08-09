package me.feng3d.fagalRE
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterArray;
	import me.feng3d.debug.assert;
	import me.feng3d.fagal.base.math.FagalMath;

	/**
	 * Fagal运行环境空间
	 * @author warden_feng 2015-7-23
	 */
	public dynamic class FagalRESpace extends Proxy
	{
		private var callLog:FagalCallLog;

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

			if (FagalRESpace.prototype[attr] != null)
			{
				return FagalRESpace.prototype[attr];
			}

			if (registerCenter.hasOwnProperty(attr))
			{
				var value:* = FagalRESpace.prototype[attr] = registerCenter[attr];
				return value;
			}

			throw new ReferenceError("在 " + getQualifiedClassName(this) + " 上找不到属性 " + attr + "，且没有默认值");
		}

		/**
		 * @inheritDoc
		 */
		override flash_proxy function callProperty(name:*, ... parameters):*
		{
			var funcName:String = String(name);
			var func:Function = math[funcName];
			assert(func != null, "在Fagal中尝试调用" + getQualifiedClassName(math) + "中不存在的函数");

			callLog.add(funcName, parameters)
		}

		/**
		 * 执行渲染函数
		 * @param fagalMethod
		 * @return
		 */
		public function run(fagalMethod:Function):FagalCallLog
		{
			callLog = new FagalCallLog();

			fagalMethod();

			return callLog;
		}

		/**
		 * 获取临时寄存器
		 * @param description 寄存器描述
		 * @return
		 * @author warden_feng 2015-4-24
		 */
		public function getFreeTemp(description:String = ""):Register
		{
			var register:Register = FagalRegisterCenter.getFreeTemp(description);
			return register;
		}

		/**
		 * 获取临时寄存器
		 * @param description 寄存器描述
		 * @return
		 * @author warden_feng 2015-4-24
		 */
		public function getFreeTemps(description:String = "", num:int = 1):RegisterArray
		{
			var register:RegisterArray = FagalRegisterCenter.getFreeTemps(description, num) as RegisterArray;
			return register;
		}
	}
}

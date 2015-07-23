package me.feng3d.fagalRE
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;

	/**
	 * Fagal寄存器中心
	 * @author warden_feng 2015-7-23
	 */
	public dynamic class FagalRegisterCenter extends Proxy
	{
		private static var _instance:FagalRegisterCenter;

		/**
		 * 构建Fagal寄存器中心
		 */
		public function FagalRegisterCenter()
		{
			if (_instance)
				throw new Error("该类为单例");
			_instance = this;
		}

		/**
		 * @inheritDoc
		 */
		override AS3 function hasOwnProperty(V:* = null):Boolean
		{
			var attr:String = V;
			return FagalRE.idDic[attr] != null;
		}

		/**
		 * @inheritDoc
		 */
		override flash_proxy function getProperty(name:*):*
		{
			var attr:String = name;

			var idData:Array = FagalRE.idDic[attr];
			//获取寄存器
			var register:Register = requestRegister(idData[0]);
			register.description = idData[1];
			return register;
		}

		/**
		 * Fagal寄存器中心实例
		 */
		public static function get instance():FagalRegisterCenter
		{
			return _instance || new FagalRegisterCenter();
		}
	}
}

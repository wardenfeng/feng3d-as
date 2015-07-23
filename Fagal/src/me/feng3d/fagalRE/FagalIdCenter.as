package me.feng3d.fagalRE
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	 * Fagal编号中心
	 * @author warden_feng 2015-7-23
	 */
	public dynamic class FagalIdCenter extends Proxy
	{
		private static var _instance:FagalIdCenter;

		/**
		 * 创建Fagal编号中心
		 */
		public function FagalIdCenter()
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

			if (!hasOwnProperty(attr))
			{
				throw new Error("不存在" + attr + "的Fagal编号");
			}
			return attr;
		}

		/**
		 * Fagal编号中心实例
		 */
		public static function get instance():FagalIdCenter
		{
			return _instance || new FagalIdCenter();
		}
	}
}

package me.feng3d.fagalRE
{
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.getQualifiedClassName;

	import me.feng3d.arcanefagal;
	import me.feng3d.core.register.RegisterType;
	import me.feng3d.core.register.RegisterVectorComplexItem;
	import me.feng3d.core.register.ShaderRegisterCache;
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.base.math.FagalMath;

	use namespace arcanefagal;

	/**
	 * Fagal运行环境空间
	 * @author warden_feng 2015-7-23
	 */
	public dynamic class FagalRESpace extends Proxy
	{
		private var _math:FagalMath;

		/**
		 * 使用寄存器计数字典
		 */
		public var useRegDic:Dictionary;

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

		public var callLog:Array;

		/**
		 * @inheritDoc
		 */
		override flash_proxy function callProperty(name:*, ... parameters):*
		{
			var funcName:String = String(name);
			var func:Function = math[funcName];

			//针对使用到的寄存器计数
			if (funcName != "comment")
			{
				for each (var reg:IField in parameters)
				{
					var registerVectorComplexItem:RegisterVectorComplexItem = reg as RegisterVectorComplexItem;
					if (registerVectorComplexItem != null)
					{
						for each (var complexArg:IField in registerVectorComplexItem.complexArgs)
						{
							//记录寄存器使用次数
							useRegDic[complexArg.regId] = int(useRegDic[complexArg.regId]) + 1;
						}
					}
					//记录寄存器使用次数
					useRegDic[reg.regId] = int(useRegDic[reg.regId]) + 1;
				}
				callLog.push({funcName: funcName, parameters: parameters});
			}

			return func.apply(null, parameters);
		}

		public function clear():void
		{
			useRegDic = new Dictionary();
			callLog = [];
		}

		/**
		 * 处理寄存器值(va0,vc0....)
		 */
		public function requestRegisterValue():void
		{
			FagalRE.instance.runState = FagalRE.RUN;

			var parameters:Array;
			for (var i:int = 0; i < callLog.length; i++)
			{
				parameters = callLog[i].parameters;

				for each (var reg:IField in parameters)
				{
					var registerVectorComplexItem:RegisterVectorComplexItem = reg as RegisterVectorComplexItem;
					if (registerVectorComplexItem != null)
					{
						for each (var complexArg:IField in registerVectorComplexItem.complexArgs)
						{
							//申请寄存器 此处并不会重复申请，内部有判断过滤
							regCache.requestRegister(complexArg.regId);

							useRegDic[complexArg.regId]--;
							//移除临时寄存器
							if (useRegDic[complexArg.regId] == 0 && RegisterType.isTemp(complexArg))
							{
								regCache.removeTempUsage(complexArg.regId);
							}

						}
					}

					//申请寄存器 此处并不会重复申请，内部有判断过滤
					regCache.requestRegister(reg.regId);

					useRegDic[reg.regId]--;
					//移除临时寄存器
					if (useRegDic[reg.regId] == 0 && RegisterType.isTemp(reg))
					{
						regCache.removeTempUsage(reg.regId);
					}
				}
			}

			FagalRE.instance.runState = FagalRE.PRERUN;
		}

		public function doCallLog():void
		{
			FagalRE.instance.runState = FagalRE.RUN;

			var funcName:String;
			var parameters:Array;
			for (var i:int = 0; i < callLog.length; i++)
			{
				funcName = callLog[i].funcName;
				parameters = callLog[i].parameters;

				var func:Function = math[funcName];
				func.apply(null, parameters)
			}
		}

		/**
		 * 寄存器缓存
		 */
		arcanefagal function get regCache():ShaderRegisterCache
		{
			return ShaderRegisterCache.instance;
		}
	}
}

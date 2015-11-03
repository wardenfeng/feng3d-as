package me.feng3d.fagalRE
{
	import flash.utils.Dictionary;

	import me.feng3d.arcanefagal;
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.ShaderRegisterCache;
	import me.feng.debug.assert;
	import me.feng3d.events.FagalMathEvent;
	import me.feng3d.fagal.FagalToken;
	import me.feng3d.fagal.base.math.FagalMath;

	use namespace arcanefagal;

	/**
	 * Fagal渲染结果
	 * @author feng 2015-8-8
	 */
	public class FagalShaderResult
	{
		public var vertexCallLog:Vector.<FagalItem>;
		public var fragmentCallLog:Vector.<FagalItem>;

		private var _math:FagalMath;

		private var agalCode:String = "";

		private var regDic:Dictionary;


		public var vertexFCode:String;
		public var vertexCode:String;

		public var fragmentFCode:String;
		public var fragmentCode:String;

		/**
		 * 创建一个Fagal渲染结果
		 */
		public function FagalShaderResult()
		{
		}

		/**
		 * 打印输出结果
		 */
		public function print():void
		{
			vertexFCode = doCallLog(vertexCallLog, Register.NAME);
			fragmentFCode = doCallLog(fragmentCallLog, Register.NAME);

			requestRegisterValue();

			vertexCode = doCallLog(vertexCallLog, Register.VALUE);
			fragmentCode = doCallLog(fragmentCallLog, Register.VALUE);

			logger("------------Compiling Register info------------------");

			for each (var register:Register in regDic)
			{
				logger(register.desc);
			}

			logger("Compiling FAGAL Code:");
			logger("--------------------");
			logger(vertexFCode);
			logger("--------------------");
			logger(fragmentFCode);

			logger("Compiling AGAL Code:");
			logger("--------------------");
			logger(vertexCode);
			logger("--------------------");
			logger(fragmentCode);

			logger("------------Compiling info end------------------");
		}

		/**
		 * 根据寄存器引用计数进行申请与释放寄存器
		 * 处理寄存器值(va0,vc0....)
		 */
		public function requestRegisterValue():void
		{
			//使用寄存器计数字典
			var useRegDic:Dictionary = new Dictionary();

			var callLog:Vector.<FagalItem> = vertexCallLog.concat(fragmentCallLog);

			var i:int;
			var regCountDic:Dictionary;
			var regId:String;
			var fagalItem:FagalItem;
			for (i = 0; i < callLog.length; i++)
			{
				fagalItem = callLog[i];

				regCountDic = fagalItem.getRegCountDic();
				for (regId in regCountDic)
				{
					//记录寄存器使用次数
					useRegDic[regId] = int(useRegDic[regId]) + int(regCountDic[regId]);
				}
			}

			for (i = 0; i < callLog.length; i++)
			{
				regCountDic = callLog[i].getRegCountDic();
				//申请寄存器
				for (regId in regCountDic)
				{
					//申请寄存器 此处并不会重复申请，内部有判断过滤
					regCache.requestRegister(regId);
				}

				//注：申请寄存器与释放临时寄存器需要分开处理，如此可避免同一个agal函数中有两个不同的数据使用相同的寄存器

				//计算使用计数，释放计数为0的临时寄存器
				for (regId in regCountDic)
				{
					//记录寄存器使用次数
					useRegDic[regId] = int(useRegDic[regId]) - int(regCountDic[regId]);

					//移除临时寄存器
					if (useRegDic[regId] == 0)
					{
						regCache.removeTempUsage(regId);
					}
				}

			}

			regDic = new Dictionary();
			var register:Register;
			Register.TO_STRING = Register.NAME;
			for (regId in useRegDic)
			{
				assert(useRegDic[regId] == 0, "不应该存在寄存器使用次数为负数的情况");
				register = FagalRegisterCenter.dataRegisterDic[regId];
				regDic[register.regId] = register;
			}
		}

		private var fagalCodeList:Array;

		/**
		 * 执行Fagal函数记录
		 */
		public function doCallLog(callLog:Vector.<FagalItem>, type:String):String
		{
			Register.TO_STRING = type;

			fagalCodeList = [];

			math.addEventListener(FagalMathEvent.FAGALMATHEVENT_APPEND, onFagalCodeAppend);

			var funcName:String;
			var parameters:Array;
			for (var i:int = 0; i < callLog.length; i++)
			{
				funcName = callLog[i].funcName;
				parameters = callLog[i].parameters;

				var func:Function = math[funcName];
				func.apply(null, parameters)
			}

			math.removeEventListener(FagalMathEvent.FAGALMATHEVENT_APPEND, onFagalCodeAppend);

			var fagalCode:String = fagalCodeList.join(FagalToken.BREAK);
			return fagalCode;
		}

		/**
		 * 寄存器缓存
		 */
		private function get regCache():ShaderRegisterCache
		{
			return ShaderRegisterCache.instance;
		}

		/**
		 * Fagal数学运算
		 */
		private function get math():FagalMath
		{
			if (_math == null)
			{
				_math = new FagalMath();
			}
			return _math;
		}

		/**
		 * 处理Fagal数学函数事件
		 */
		private function onFagalCodeAppend(event:FagalMathEvent):void
		{
			fagalCodeList.push(event.code);
		}
	}
}

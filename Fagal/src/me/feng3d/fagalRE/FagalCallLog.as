package me.feng3d.fagalRE
{
	import flash.utils.Dictionary;

	import me.feng3d.arcanefagal;
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.ShaderRegisterCache;
	import me.feng3d.debug.assert;
	import me.feng3d.events.FagalMathEvent;
	import me.feng3d.fagal.FagalToken;
	import me.feng3d.fagal.base.math.FagalMath;

	use namespace arcanefagal;

	/**
	 *
	 * @author warden_feng 2015-8-8
	 */
	public class FagalCallLog
	{
		/**
		 * 调用Fagal函数记录
		 */
		private var callLog:Vector.<FagalItem>;

		private var _math:FagalMath;

		private var agalCode:String = "";

		public function FagalCallLog()
		{
			callLog = new Vector.<FagalItem>();
		}

		public function add(funcName:String, parameters:Array):void
		{
			callLog.push(new FagalItem(funcName, parameters));
		}

		/**
		 * 根据寄存器引用计数进行申请与释放寄存器
		 * 处理寄存器值(va0,vc0....)
		 */
		public function requestRegisterValue():void
		{
			Register.TO_STRING = Register.VALUE;

			//使用寄存器计数字典
			var useRegDic:Dictionary = new Dictionary();

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
				for (regId in regCountDic)
				{
					//申请寄存器 此处并不会重复申请，内部有判断过滤
					regCache.requestRegister(regId);

					//记录寄存器使用次数
					useRegDic[regId] = int(useRegDic[regId]) - int(regCountDic[regId]);

					//移除临时寄存器
					if (useRegDic[regId] == 0)
					{
						regCache.removeTempUsage(regId);
					}
					assert(useRegDic[regId] >= 0, "不应该存在寄存器使用次数为负数的情况");
				}
			}

			Register.TO_STRING = Register.NAME;
		}

		private var fagalCodeList:Array;

		/**
		 * 执行Fagal函数记录
		 */
		public function doCallLog(type:String):String
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

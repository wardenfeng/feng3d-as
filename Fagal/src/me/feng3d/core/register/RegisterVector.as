package me.feng3d.core.register
{
	import me.feng3d.fagal.RegisterComponent;

	/**
	 * 寄存器数组
	 * @author warden_feng 2014-11-4
	 */
	public class RegisterVector extends Register
	{
		private var _regs:Vector.<Register>;

		/**
		 * 创建一个寄存器数组
		 * @param regType			寄存器类型编号
		 * @param start				起始编号
		 * @param num				寄存器个数
		 */
		public function RegisterVector(regType:String, start:int, num:int)
		{
			super(regType, start);
			_regs = new Vector.<Register>(num, true);
		}

		/**
		 * 第一个寄存器
		 */
		public function get first():Register
		{
			return getReg(0);
		}

		/**
		 * 最后一个寄存器
		 */
		public function get last():Register
		{
			return getReg(_regs.length - 1);
		}

		/**
		 * 获取寄存器链表中的元素
		 * @param $index 链表中的位置
		 * @return 寄存器
		 */
		public function getReg($index:uint):Register
		{
			if (!_regs[$index])
			{
				var reg:Register = _regs[$index] = new Register(_regType, _index + $index);
				reg.regId = regId;
			}
			return _regs[$index];
		}

		/**
		 * 获取寄存器向量中的寄存器
		 * @param args 索引信息
		 * @return
		 */
		public function getReg1(... args):Register
		{
			var num:int = 0;
			var numStr:String = "";

			for (var i:int = 0; i < args.length; i++)
			{
				if (args[i] is uint)
				{
					num += args[i];
				}
				else if (args[i] is RegisterComponent)
				{
					if (numStr.length > 0)
						numStr += "+";
					numStr += args[i];
				}
				else
				{
					throw new Error("不支持该类型");
				}
			}
			if (numStr.length == 0)
				return getReg(num);

			return new RegisterVectorItem(getReg(0), numStr, num);
		}
	}
}

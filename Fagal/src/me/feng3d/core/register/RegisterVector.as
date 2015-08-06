package me.feng3d.core.register
{


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
		public function RegisterVector(regId:String)
		{
			_regs = new Vector.<Register>();
			_regs.length = 1;
			super(regId);
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
			if (_regs.length < $index + 1)
			{
				_regs.length = $index + 1
			}

			if (!_regs[$index])
			{
				var reg:RegisterVectorItem = new RegisterVectorItem(this, $index);
				_regs[$index] = reg;
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
			var index:int = 0;

			var complexArgs:Array = [];

			for (var i:int = 0; i < args.length; i++)
			{
				if (args[i] is uint)
				{
					index += args[i];
				}
				else
				{
					complexArgs.push(args[i]);
				}
			}
			if (complexArgs.length == 0)
				return getReg(index);

			return new RegisterVectorComplexItem(this, complexArgs, index);
		}

		override public function get regLen():uint
		{
			return _regs.length;
		}

		public function set regLen(value:uint):void
		{
			_regs.length = value;
		}

		override public function clear():void
		{
			_regs.length = 1;
			super.clear();
		}
	}
}

package me.feng3d.fagal
{
	import me.feng3d.core.register.Register;

	/**
	 * 寄存器单元
	 * @author warden_feng 2014-10-22
	 */
	public class RegisterComponent implements IRegisterComponent
	{
		private var _register:Register;
		private var _prop:String;
		private var _regType:String;

		private var _regId:String;

		protected var _registerString:String;
		protected var _nameString:String;

		/** 寄存器id */
		public function get regId():String
		{
			return _regId;
		}

		/**
		 * @private
		 */
		public function set regId(value:String):void
		{
			_regId = value;
		}

		/**
		 * 创建一个寄存器单元
		 * @param register 寄存器类型
		 * @param prop 单元名称
		 */
		public function RegisterComponent(register:Register, prop:String)
		{
			_prop = prop;
			_register = register;
			_regType = register.regType;
			_regId = register.regId;

			if (!valid(prop))
				throw new Error("无效寄存器分量: " + _register);
		}

		/**
		 * @inheritDoc
		 */
		public function get regType():String
		{
			return _regType;
		}

		public function toString():String
		{
			return _register + "." + _prop;
		}

		/**
		 * 判断是否有效
		 * @param prop
		 * @return			true：有效，false：无效
		 */
		public static function valid(prop:String):Boolean
		{
			switch (prop)
			{
				case "x":
				case "y":
				case "z":
				case "w":
				case "r":
				case "g":
				case "b":
				case "a":
					return true;
			}
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function get desc():String
		{
			return toString();
		}
	}
}

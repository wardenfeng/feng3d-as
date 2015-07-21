package me.feng3d.core.register
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	import me.feng3d.fagal.RegisterComponent;
	import me.feng3d.fagal.RegisterComponentSelection;
	import me.feng3d.fagal.IRegister;

	/**
	 * 寄存器(链表)
	 * @author warden_feng 2014-6-9
	 */
	public dynamic class Register extends Proxy implements IRegister
	{
		private static const COMPONENTS:Array = ["x", "y", "z", "w"];

		protected var _regType:String;
		protected var _index:int = -1;
		protected var _toStr:String;

		/** 寄存器id */
		public var regId:String;

		/** 描述 */
		public var description:String;

		/**
		 * 创建一个寄存器
		 * @param regType 寄存器名称
		 * @param index 寄存器编号
		 */
		public function Register(regType:String, index:int)
		{
			_regType = regType;
			_index = index;

			_toStr = _regType;
			if (_regType != RegisterType.OP && _regType != RegisterType.OC)
				_toStr += _index;
		}

		public function get regType():String
		{
			return _regType;
		}

		/**
		 * 寄存器编号
		 */
		public function get index():int
		{
			return _index;
		}

		public function toString():String
		{
			return _toStr;
		}

		/**
		 * 寄存器分量
		 * @param component 分量编号
		 * @return 寄存器分量
		 */
		public function c(component:int):RegisterComponent
		{
			return new RegisterComponent(this, COMPONENTS[component]);
		}

		/**
		 * 获取寄存器分量
		 * @param name 分量名称
		 * @return
		 */
		override flash_proxy function getProperty(name:*):*
		{
			var components:String = name;

			if (components.length == 0)
				throw new Error("无效寄存器分量: " + this + "." + components);

			if (components.length > 4)
				throw new Error("无效寄存器分量: " + this + "." + components);
			for (var i:int = 0; i < components.length; i++)
			{
				if (!RegisterComponent.valid(components.substr(i, 1)))
					throw new Error("无效寄存器分量: " + this + "." + components);
			}

			if (components.length == 1)
			{
				return new RegisterComponent(this, components.toLowerCase());
			}
			return new RegisterComponentSelection(this, components.toLowerCase());
		}

		/**
		 * @inheritDoc
		 */
		override flash_proxy function callProperty(name:*, ... parameters):*
		{
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function get desc():String
		{
			if (description && description.length > 0)
				return toString() + "[" + description + "]";
			return toString();
		}

	}
}

package me.feng3d.core.register
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	import me.feng3d.core.buffer.Context3DBufferTypeManager;
	import me.feng3d.core.buffer.type.Context3DBufferType;
	import me.feng3d.fagal.IRegister;
	import me.feng3d.fagal.RegisterComponent;
	import me.feng3d.fagal.RegisterComponentSelection;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 寄存器(链表)
	 * @author warden_feng 2014-6-9
	 */
	public dynamic class Register extends Proxy implements IRegister
	{
		/**
		 * 寄存器中元素数组
		 */
		private static const COMPONENTS:Array = ["x", "y", "z", "w"];

		protected var _regType:String;
		protected var _index:int = -1;

		private var _regId:String;

		/** 描述 */
		public var description:String;

		/**
		 * 寄存器编号
		 */
		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}

		/** 寄存器id */
		public function get regId():String
		{
			return _regId;
		}

		public function get regType():String
		{
			return _regType;
		}

		/**
		 * 创建一个寄存器
		 * @param regId			寄存器id
		 */
		public function Register(regId:String)
		{
			_regId = regId;

			init();
		}

		/**
		 * 初始化
		 */
		private function init():void
		{
			var bufferType:Context3DBufferType = Context3DBufferTypeManager.getBufferType(_regId);
			_regType = bufferType.registerType;
			_index = -1;
		}

		/**
		 * @inheritDoc
		 */
		public function toString():String
		{
			if (FagalRE.instance.runState == FagalRE.PRERUN)
				return "{" + regId + "}";

			if (_regType != RegisterType.OP && _regType != RegisterType.OC)
				return _regType + _index;
			return _regType;
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

		/**
		 * @inheritDoc
		 */
		public function get regLen():uint
		{
			return 1;
		}

		/**
		 * 清理寄存器值
		 */
		public function clear():void
		{
			index = -1;
		}
	}
}

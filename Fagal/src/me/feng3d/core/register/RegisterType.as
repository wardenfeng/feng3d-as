package me.feng3d.core.register
{


	/**
	 * 寄存器类型
	 * @author warden_feng 2014-6-9
	 */
	public class RegisterType
	{
		/** 顶点属性寄存器 */
		public static const VA:String = "va";

		/** 顶点程序常量寄存器 */
		public static const VC:String = "vc";

		/** 顶点临时寄存器 */
		public static const VT:String = "vt";

		/** 顶点程序输出寄存器 */
		public static const OP:String = "op";

		/**变量寄存器 */
		public static const V:String = "v";

		/** 片段程序的纹理寄存器 */
		public static const FS:String = "fs";

		/** 片段程序常量寄存器 */
		public static const FC:String = "fc";

		/** 片段程序临时寄存器 */
		public static const FT:String = "ft";

		/** 片段程序输出寄存器 */
		public static const OC:String = "oc";

		/**
		 * 是否常量
		 * @param regType		寄存器类型
		 */
		public static function isConst(regType:String):Boolean
		{
			return regType == VC || regType == FC;
		}

		/**
		 * 是否临时变量
		 * @param regType		寄存器类型
		 */
		public static function isTemp(regType:String):Boolean
		{
			return regType == VT || regType == FT;
		}

		/**
		 * 是否只读
		 * @param regType		寄存器类型
		 * @return
		 */
		public static function isReadOnly(regType:String):Boolean
		{
			switch (regType)
			{
				case VA:
					return true;
				case VC:
					return true;
				case VT:
					return false;
				case OP:
					return false;
				case V:
					return false;
				case FS:
					return true;
				case FC:
					return true;
				case FT:
					return false;
				case OC:
					return false;
			}
			throw new Error("错误寄存器类型");
		}

		/**
		 * 是否可以在顶点寄存器中出现
		 * @param regType		寄存器类型
		 * @return
		 */
		public static function inVertex(regType:String):Boolean
		{
			switch (regType)
			{
				case VA:
					return true;
				case VC:
					return true;
				case VT:
					return true;
				case OP:
					return true;
				case V:
					return true;
				case FS:
					return false;
				case FC:
					return false;
				case FT:
					return false;
				case OC:
					return false;
			}
			throw new Error("错误寄存器类型");
		}

		/**
		 * 是否可以在片段寄存器中出现
		 * @param regType		寄存器类型
		 * @return
		 */
		public static function inFragment(regType:String):Boolean
		{
			switch (regType)
			{
				case VA:
					return false;
				case VC:
					return false;
				case VT:
					return false;
				case OP:
					return false;
				case V:
					return true;
				case FS:
					return true;
				case FC:
					return true;
				case FT:
					return true;
				case OC:
					return true;
			}
			throw new Error("错误寄存器类型");
		}

		/**
		 * 是否为输入数据寄存器
		 * @param regType		寄存器类型
		 * @return
		 */
		public static function isInputDataRegister(regType:String):Boolean
		{
			switch (regType)
			{
				case VA:
					return true;
				case VC:
					return true;
				case VT:
					return false;
				case OP:
					return false;
				case V:
					return false;
				case FS:
					return true;
				case FC:
					return true;
				case FT:
					return false;
				case OC:
					return false;
			}
			throw new Error("错误寄存器类型");
		}
	}
}

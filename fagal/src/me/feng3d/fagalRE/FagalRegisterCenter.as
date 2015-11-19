package me.feng3d.fagalRE
{
	import flash.display3D.Context3DProgramType;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	import me.feng3d.arcanefagal;
	import me.feng3d.core.buffer.Context3DBufferTypeManager;
	import me.feng3d.core.buffer.RgisterDataType;
	import me.feng3d.core.buffer.type.Context3DBufferType;
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterArray;
	import me.feng3d.core.register.RegisterMatrix;

	use namespace arcanefagal;

	/**
	 * Fagal寄存器中心
	 * @author feng 2015-7-23
	 */
	public dynamic class FagalRegisterCenter extends Proxy
	{
		private static var _instance:FagalRegisterCenter;

		private static var _dataRegisterDic:Dictionary;

		/**
		 * 临时寄存器递增索引（目的是为了获取唯一的临时寄存器名称，顶点与片段临时寄存器公用一个递增索引）
		 */
		private static var tempIndex:int;

		/**
		 * 构建Fagal寄存器中心
		 */
		public function FagalRegisterCenter()
		{
			if (_instance)
				throw new Error("该类为单例");
			_instance = this;
		}

		/**
		 * 数据寄存器缓存
		 */
		public static function get dataRegisterDic():Dictionary
		{
			return _dataRegisterDic ||= new Dictionary();
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

			var idData:Array = FagalRE.idDic[attr];
			//获取寄存器
			var register:Register = createRegister(idData[0]);
			register.description = idData[1];
			return register;
		}

		/**
		 * 创建寄存器
		 * @param dataTypeId
		 * @param numRegister
		 * @return
		 */
		public static function createRegister(dataTypeId:String):Register
		{
			if (dataRegisterDic[dataTypeId])
				return dataRegisterDic[dataTypeId];

			var bufferType:Context3DBufferType = Context3DBufferTypeManager.getBufferType(dataTypeId);

			var register:Register;
			if (bufferType.dataType == RgisterDataType.MATRIX)
			{
				//获取寄存器矩阵
				register = new RegisterMatrix(dataTypeId);
			}
			else if (bufferType.dataType == RgisterDataType.ARRAY)
			{
				register = new RegisterArray(dataTypeId);
			}
			else if (bufferType.dataType == RgisterDataType.VECTOR)
			{
				//获取寄存器数组
				register = new RegisterArray(dataTypeId);
			}
			else
			{
				register = new Register(dataTypeId);
			}

			dataRegisterDic[dataTypeId] = register;
			return register;
		}

		/**
		 * 获取临时寄存器
		 * @param description 寄存器描述
		 * @return
		 * @author feng 2015-4-24
		 */
		public static function getFreeTemp(description:String = ""):Register
		{
			var tempTypeId:String;
			if (FagalRE.instance.shaderType == Context3DProgramType.VERTEX)
			{
				tempTypeId = "temp" + (tempIndex++) + "_vt_4";
			}
			else if (FagalRE.instance.shaderType == Context3DProgramType.FRAGMENT)
			{
				tempTypeId = "temp" + (tempIndex++) + "_ft_4";
			}

			var register:Register = createRegister(tempTypeId);
			register.description = description;

			return register;
		}

		/**
		 * 获取临时寄存器
		 * @param description 寄存器描述
		 * @return
		 * @author feng 2015-4-24
		 */
		public static function getFreeTemps(description:String = "", num:int = 1):Register
		{
			var tempTypeId:String;
			if (FagalRE.instance.shaderType == Context3DProgramType.VERTEX)
			{
				if (num > 1)
				{
					tempTypeId = "temp" + (tempIndex++) + "_vt_" + RgisterDataType.ARRAY;
				}
				else
				{
					tempTypeId = "temp" + (tempIndex++) + "_vt_4";
				}
			}
			else if (FagalRE.instance.shaderType == Context3DProgramType.FRAGMENT)
			{
				if (num > 1)
				{
					tempTypeId = "temp" + (tempIndex++) + "_ft_" + RgisterDataType.ARRAY;
				}
				else
				{
					tempTypeId = "temp" + (tempIndex++) + "_ft_4";
				}
			}

			var register:Register = createRegister(tempTypeId);
			register.description = description;

			return register;
		}

		/**
		 * 清理寄存器值
		 */
		public static function clear():void
		{
			for each (var register:Register in dataRegisterDic)
			{
				register.clear();
			}
		}

		/**
		 * Fagal寄存器中心实例
		 */
		public static function get instance():FagalRegisterCenter
		{
			return _instance || new FagalRegisterCenter();
		}
	}
}

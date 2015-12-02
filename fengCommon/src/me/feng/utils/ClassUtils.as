package me.feng.utils
{
	import flash.geom.Matrix3D;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * 类工具
	 * @author feng 2015-4-27
	 */
	public class ClassUtils
	{
		/**
		 * 基础类型列表
		 */
		public static const BASETYPES:Array = [int, Boolean, Number, uint, String, null];

		/**
		 * 获取类定义
		 * @param obj
		 * @return
		 */
		public static function getClass(obj:*):Class
		{
			if (obj is String)
			{
				return getDefinitionByName(obj) as Class;
			}

			var cla:Class = obj as Class;

			if (cla == null)
			{
				cla = getDefinitionByName(getQualifiedClassName(obj)) as Class;
			}

			return cla;
		}

		/**
		 * 获取类实例
		 * @param obj
		 * @return
		 */
		public static function getInstance(obj:*):*
		{
			if (obj is Class)
			{
				return new obj();
			}
			if (obj is String)
			{
				var cla:Class = getClass(obj) as Class;
				return new cla;
			}
			return obj;
		}

		/**
		 * 构造实例
		 * @param cla						类定义
		 * @param params					构造参数
		 * @return							构造出的实例
		 */
		public static function structureInstance(cla:Class, params:Array):*
		{
			if (params == null)
			{
				return new cla();
			}

			var paramNum:int = params.length;
			switch (paramNum)
			{
				case 0:
					return new cla();
					break;
				case 1:
					return new cla(params[0]);
					break;
				case 2:
					return new cla(params[0], params[1]);
					break;
				case 3:
					return new cla(params[0], params[1], params[2]);
					break;
				case 4:
					return new cla(params[0], params[1], params[2], params[3]);
					break;
				case 5:
					return new cla(params[0], params[1], params[2], params[3], params[4]);
					break;
				case 6:
					return new cla(params[0], params[1], params[2], params[3], params[4], params[5]);
					break;
				case 7:
					return new cla(params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
					break;
				case 8:
					return new cla(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7]);
					break;
				case 9:
					return new cla(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8]);
					break;
				case 10:
					return new cla(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9]);
					break;
				default:
					throw new Error("不支持" + paramNum + "个参数的类构造");
					break;
			}
			return null;
		}

		/**
		 * 构造实例
		 * @param space						运行空间
		 * @param funcName					函数名称
		 * @param params					函数参数
		 * @return							函数返回值
		 */
		public static function call(space:Object, funcName:String, params:Array):*
		{
			var func:Function = space[funcName];
			var result:* = func.apply(null, params);
			return result;
		}

		/**
		 * 编码参数
		 * @param params		参数数组
		 */
		public static function encodeParams(params:Array):void
		{
			for (var i:int = 0; i < params.length; i++)
			{
				var item:Object = params[i];
				var paramType:String = getQualifiedClassName(item);
				params[i] = {paramType: paramType, paramValue: item};
			}
		}

		/**
		 * 解码参数
		 * @param params		参数数组
		 */
		public static function decodeParams(params:Array):void
		{
			for (var i:int = 0; i < params.length; i++)
			{
				var item:Object = params[i];

				if (item.hasOwnProperty("paramType") && item.hasOwnProperty("paramValue"))
				{
					var obj:Object;
					if (item.paramType == "flash.geom::Matrix3D")
					{
						obj = new Matrix3D(Vector.<Number>(item.paramValue.rawData));
					}
					else
					{
						obj = ClassUtils.getInstance(item.paramType);
						if (isBaseType(item.paramValue))
						{
							obj = item.paramValue;
						}
						else
						{
							copyValue(obj, item.paramValue);
						}
					}
					params[i] = obj;
				}
			}
		}

		/**
		 * 拷贝数据
		 * @param obj			需要赋值的对象
		 * @param value			拥有数据的对象
		 */
		public static function copyValue(obj:Object, value:Object):void
		{
			for (var key:String in value)
			{
				var attrValue:* = value[key];
				var attrType:String = getQualifiedClassName(attrValue);
				var baseType:Boolean = isBaseType(value[key]);
				if (baseType)
				{
					obj[key] = value[key];
				}
				else
				{
					copyValue(obj[key], value[key]);
				}
			}
		}

		/**
		 * 判断对象是否为基础类型
		 * @param obj			对象
		 * @return				true为基础类型，false为复杂类型
		 */
		public static function isBaseType(obj:Object):Boolean
		{
			if (obj is String)
			{
				return true;
			}
			var type:Class = getClass(obj);
			var index:int = BASETYPES.indexOf(type);
			return index != -1;
		}

		/**
		 * 获取对象默认名称
		 * @param obj				对象
		 * @return					对象默认名称
		 */
		public static function getDefaultName(obj:Object):String
		{
			return getQualifiedClassName(obj).split("::").pop();
		}
	}
}

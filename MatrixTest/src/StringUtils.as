package
{
	import flash.geom.Matrix3D;

	public class StringUtils
	{
		/**
		 * 获取字符串
		 * @param obj 转换为字符串的对象
		 * @param showLen       显示长度
		 * @param fill          长度不够是填充的字符串
		 * @param tail          true（默认）:在尾部添加；false：在首部添加
		 */
		public static function getString(obj:Object, showLen:Number = -1, fill = " ", tail:Boolean = true):String
		{
			var str:String = "";
			if (obj.toString != null)
			{
				str = obj.toString();
			}
			else
			{
				str = obj as String;
			}

			if (showLen != -1)
			{
				while (str.length < showLen)
				{
					if (tail)
					{
						str = str + fill;
					}
					else
					{
						str = fill + str;
					}
				}
				if (str.length > showLen)
				{
					str = str.substr(0, showLen);
				}
			}

			return str;
		}

		/**
		 * 以字符串返回矩阵的值
		 */
		public static function toMatrix3DString(matrix3D:Matrix3D):String
		{
			var str:String = "";
			var showLen:int = 5;
			var precision:int = Math.pow(10, showLen - 1);

			for (var i:int = 0; i < 4; i++)
			{
				for (var j:int = 0; j < 4; j++)
				{
					str += StringUtils.getString(Math.round(matrix3D.rawData[i * 4 + j] * precision) / precision, showLen + 1, " ");
				}
				if (i != 3)
					str += "\n";
			}
			return str;
		}
	}
}

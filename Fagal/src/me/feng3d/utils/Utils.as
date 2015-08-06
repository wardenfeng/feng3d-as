package me.feng3d.utils
{

	/**
	 * 临时工具类
	 * @author warden_feng 2015-7-29
	 */
	public class Utils
	{
		public function Utils()
		{
		}

		/**
		 * 清理注释
		 * @param str
		 * @return
		 */
		public static function clearComment(str:String):String
		{
			var lines:Array = str.split("\n");
			var lineStr:String;
			for (var i:int = lines.length - 1; i >= 0; i--)
			{
				lineStr = lines[i];
				if (lineStr.substr(0, 2) == "\/\/")
				{
					lines.splice(i, 1);
				}
			}
			var newStr:String = lines.join("\n");

			return newStr;
		}
	}
}

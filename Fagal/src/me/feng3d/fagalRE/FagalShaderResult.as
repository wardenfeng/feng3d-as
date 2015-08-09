package me.feng3d.fagalRE
{

	/**
	 * Fagal渲染结果
	 * @author warden_feng 2015-8-8
	 */
	public class FagalShaderResult
	{
		public var vertexFCode:String;
		public var vertexCode:String;

		public var fragmentFCode:String;
		public var fragmentCode:String;

		/**
		 * 创建一个Fagal渲染结果
		 */
		public function FagalShaderResult()
		{
		}

		/**
		 * 打印输出结果
		 */
		public function print():void
		{
			logger("Compiling FAGAL Code:");
			logger("--------------------");
			logger(vertexFCode);
			logger("--------------------");
			logger(fragmentFCode);

			logger("Compiling AGAL Code:");
			logger("--------------------");
			logger(vertexCode);
			logger("--------------------");
			logger(fragmentCode);
		}
	}
}

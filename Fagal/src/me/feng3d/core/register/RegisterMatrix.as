package me.feng3d.core.register
{

	/**
	 * 寄存器矩阵
	 * @author feng 2014-11-4
	 */
	public class RegisterMatrix extends RegisterArray
	{
		/**
		 *
		 * @param regId
		 */
		public function RegisterMatrix(regId:String)
		{
			super(regId);

			regLen = 4;
		}

		/**
		 * @inheritDoc
		 */
		override public function clear():void
		{
			regLen = 4;
			index = -1;
		}


	}
}

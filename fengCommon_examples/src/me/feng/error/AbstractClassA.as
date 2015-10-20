package me.feng.error
{

	/**
	 * 抽象类A
	 * @author feng 2015-5-21
	 */
	public class AbstractClassA
	{
		public function AbstractClassA()
		{
			//改行代码指定 此类为抽象类
			AbstractClassError.check(this);
		}
	}
}

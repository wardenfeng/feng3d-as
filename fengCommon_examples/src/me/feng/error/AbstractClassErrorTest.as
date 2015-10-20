package me.feng.error
{

	//测试抽象类
	//@author feng 2015-5-21
	public class AbstractClassErrorTest extends TestBase
	{
		public function AbstractClassErrorTest()
		{
			try
			{
				//此处不会报错
				new ExtendsAbstractClassA();

				//此处将会报错
				new AbstractClassA();
			}
			catch (error:Error)
			{
				trace(error);
			}
		}

		public function init():void
		{

		}
	}
}

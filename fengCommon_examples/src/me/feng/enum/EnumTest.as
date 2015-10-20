package me.feng.enum
{


	//
	// @author feng 2015-5-7
	//
	public class EnumTest extends TestBase
	{
		public function init():void
		{
			try
			{
				new TypeEnum();
			}
			catch (error:Error)
			{
				trace("[error]", error.message);
			}

			trace(TypeEnum.a);
			trace(TypeEnum.b);
			trace(TypeEnum.c);
			trace(TypeEnum.c + TypeEnum.b);

			var i:int = int(TypeEnum.c);

			f(TypeEnum.b);
//
			trace(TypeEnum1.r);
			trace(TypeEnum1.g);
			trace(TypeEnum1.b);
			trace(TypeEnum1.b + TypeEnum1.g);
		}

		private function f(type:TypeEnum):void
		{
			switch (type)
			{
				case TypeEnum.a:
					trace("aaaaaaaaaaaa");
					break;
				case TypeEnum.b:
					trace("bbbbbbbbbbbb");
					break;
//				case TypeEnum.c:
//					trace("ccccccccccc");
//					break;
			}
		}
	}
}

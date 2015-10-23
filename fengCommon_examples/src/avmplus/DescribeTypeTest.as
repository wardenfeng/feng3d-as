package avmplus
{
	import flash.display.Sprite;

	/**
	 * 反射实例
	 * @author feng 2015-10-23
	 */
	public class DescribeTypeTest extends TestBase
	{

		public function init():void
		{
			var describe:Object = describeTypeClass(Sprite);

			trace(JSON.stringify(describe));

			describe = describeTypeInstance(Sprite);

			trace(JSON.stringify(describe));
		}
	}
}

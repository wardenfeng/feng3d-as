package avmplus
{
	import flash.display.Sprite;

	/**
	 * 反射示例
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

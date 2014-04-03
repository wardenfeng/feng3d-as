package feng3d.events
{
	import flash.events.EventDispatcher;

	/**
	 *
	 * @author warden_feng 2014-3-19
	 */
	public class GameDispatcher extends EventDispatcher
	{
		private static var randomNumber:Number = Math.random();

		/**
		 *
		 * @param number
		 * @throws Error
		 */
		public function GameDispatcher(number:Number)
		{
			if (number != randomNumber)
			{
				throw new Error("此类不允许外部创建，请用instance属性！");
			}
		}

		private static var _instance:GameDispatcher;

		/**
		 *
		 * @return
		 */
		public static function get instance():GameDispatcher
		{
			_instance || (_instance = new GameDispatcher(randomNumber));
			return _instance;
		}
	}
}

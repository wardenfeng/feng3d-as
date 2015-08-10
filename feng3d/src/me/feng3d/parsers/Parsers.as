package me.feng3d.parsers
{

	/**
	 *
	 * @author warden_feng 2015-8-10
	 */
	public class Parsers
	{
		public function Parsers()
		{
		}

		/**
		 * Short-hand function to enable all bundled parsers for auto-detection. In practice,
		 * this is the same as invoking enableParsers(Parsers.ALL_BUNDLED) on any of the
		 * loader classes SingleFileLoader, AssetLoader, AssetLibrary or Loader3D.
		 *
		 * See notes about file size in the documentation for the ALL_BUNDLED constant.
		 *
		 * @see away3d.loaders.parsers.Parsers.ALL_BUNDLED
		 */
		public static function enableAllBundled():void
		{
		}
	}
}

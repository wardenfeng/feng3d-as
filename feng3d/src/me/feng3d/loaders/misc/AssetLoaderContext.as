package me.feng3d.loaders.misc
{

	/**
	 *
	 * @author warden_feng 2015-8-10
	 */
	public class AssetLoaderContext
	{
		public function AssetLoaderContext()
		{
		}

		/**
		 * Map a URL to embedded data, so that instead of trying to load a dependency from the URL at
		 * which it's referenced, the dependency data will be retrieved straight from the memory instead.
		 *
		 * @param originalUrl The original URL which is referenced in the loaded resource.
		 * @param data The embedded data. Can be ByteArray or a class which can be used to create a bytearray.
		 */
		public function mapUrlToData(originalUrl:String, data:*):void
		{

		}
	}
}

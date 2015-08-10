package me.feng3d.loaders
{
	import me.feng3d.containers.ObjectContainer3D;
	import me.feng3d.loaders.misc.AssetLoaderContext;
	import me.feng3d.loaders.misc.AssetLoaderToken;
	import me.feng3d.parsers.ParserBase;

	/**
	 *
	 * @author warden_feng 2015-8-10
	 */
	public class Loader3D extends ObjectContainer3D
	{
		public function Loader3D()
		{
		}

		/**
		 * Loads a resource from already loaded data.
		 *
		 * @param data The data object containing all resource information.
		 * @param context An optional context object providing additional parameters for loading
		 * @param ns An optional namespace string under which the file is to be loaded, allowing the differentiation of two resources with identical assets
		 * @param parser An optional parser object for translating the loaded data into a usable resource. If not provided, AssetLoader will attempt to auto-detect the file type.
		 */
		public function loadData(data:*, context:AssetLoaderContext = null, ns:String = null, parser:ParserBase = null):AssetLoaderToken
		{

			return null;
		}
	}
}

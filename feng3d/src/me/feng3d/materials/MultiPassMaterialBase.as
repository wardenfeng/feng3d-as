package me.feng3d.materials
{
	import me.feng3d.textures.Texture2DBase;

	/**
	 *
	 * @author warden_feng 2014-5-19
	 */
	public class MultiPassMaterialBase extends MaterialBase
	{
		public function MultiPassMaterialBase()
		{
			super();
		}

		public function get texture():Texture2DBase
		{
			return null;
		}

		public function set texture(value:Texture2DBase):void
		{
		}
	}
}

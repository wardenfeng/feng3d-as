package me.feng3d.textures
{
	import me.feng3d.fagal.TextureType;

	/**
	 * 纹理基类
	 * @author warden_feng 2014-4-15
	 */
	public class Texture2DBase extends TextureProxyBase
	{
		public function Texture2DBase()
		{
			super();
			type = TextureType.TYPE_2D;
		}
	}
}

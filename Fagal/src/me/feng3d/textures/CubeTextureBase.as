package me.feng3d.textures
{
	import me.feng3d.fagal.TextureType;

	/**
	 * 立方体纹理代理基类
	 * @author warden_feng 2014-7-12
	 */
	public class CubeTextureBase extends TextureProxyBase
	{
		/**
		 * 创建一个立方体纹理代理基类
		 */
		public function CubeTextureBase()
		{
			super();
			type = TextureType.TYPE_CUBE;
		}

		/**
		 * 获取纹理尺寸
		 */
		public function get size():int
		{
			return _width;
		}
	}
}

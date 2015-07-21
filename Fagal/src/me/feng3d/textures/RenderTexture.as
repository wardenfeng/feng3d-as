package me.feng3d.textures
{

	/**
	 * 渲染纹理
	 * @author warden_feng 2015-5-28
	 */
	public class RenderTexture extends Texture2DBase
	{
		/**
		 * 创建一个渲染纹理
		 * @param width			纹理宽度
		 * @param height		纹理高度
		 */
		public function RenderTexture(width:Number, height:Number)
		{
			super();
			setSize(width, height);
		}
	}
}

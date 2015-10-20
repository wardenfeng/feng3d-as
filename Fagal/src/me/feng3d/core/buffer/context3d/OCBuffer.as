package me.feng3d.core.buffer.context3d
{
	import flash.display3D.Context3D;
	import flash.display3D.textures.TextureBase;

	import me.feng3d.arcanefagal;
	import me.feng3d.core.buffer.TextureCenter;
	import me.feng3d.textures.TextureProxyBase;

	use namespace arcanefagal;

	/**
	 * 输出纹理缓冲
	 * @author feng 2015-6-3
	 */
	public class OCBuffer extends RegisterBuffer
	{
		/** 纹理数据 */
		public var texture:TextureProxyBase;

		private var enableDepthAndStencil:Boolean = true;
		private var surfaceSelector:int = 0;
		private var _antiAlias:int = 0;

		/**
		 * 创建一个输出纹理缓冲
		 * @param dataTypeId 		数据缓存编号
		 * @param updateFunc 		更新回调函数
		 */
		public function OCBuffer(dataTypeId:String, updateFunc:Function)
		{
			super(dataTypeId, updateFunc);
		}

		/**
		 * @inheritDoc
		 */
		override arcanefagal function doBuffer(context3D:Context3D):void
		{
			doUpdateFunc();
			//从纹理缓存中获取纹理
			var textureBase:TextureBase = TextureCenter.getTexture(context3D, texture);

			context3D.setRenderToTexture(textureBase, true, 0, 0, firstRegister);
		}

		/**
		 * 更新纹理数据
		 * @param texture
		 */
		public function update(texture:TextureProxyBase):void
		{
			this.texture = texture;
		}
	}
}

package me.feng3d.core.buffer.context3d
{
	import flash.display3D.Context3D;
	import flash.display3D.textures.TextureBase;

	import me.feng3d.arcanefagal;
	import me.feng3d.core.buffer.TextureCenter;
	import me.feng3d.textures.TextureProxyBase;

	use namespace arcanefagal;

	/**
	 * 纹理缓存
	 * @author warden_feng 2014-8-14
	 */
	public class FSBuffer extends RegisterBuffer
	{
		/** 纹理数据 */
		arcanefagal var texture:TextureProxyBase;

		/**
		 * 创建纹理数据缓存
		 * @param dataTypeId 	数据编号
		 * @param updateFunc 	数据更新回调函数
		 * @param textureFlags	取样参数回调函数
		 */
		public function FSBuffer(dataTypeId:String, updateFunc:Function)
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

			context3D.setTextureAt(firstRegister, textureBase);
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

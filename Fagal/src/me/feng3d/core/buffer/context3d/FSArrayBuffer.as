package me.feng3d.core.buffer.context3d
{
	import flash.display3D.Context3D;
	import flash.display3D.textures.TextureBase;
	
	import me.feng3d.arcanefagal;
	import me.feng3d.core.buffer.TextureCenter;

	use namespace arcanefagal;

	/**
	 * 纹理数组缓存（解决类似地形多纹理混合）
	 * @author warden_feng 2014-11-6
	 */
	public class FSArrayBuffer extends RegisterBuffer
	{
		/** 纹理数据 */
		public var textures:Array;

		/**
		 * 创建纹理数组缓存
		 * @param dataTypeId 数据编号
		 * @param updateFunc 数据更新回调函数
		 * @param textureFlags	取样参数回调函数
		 */
		public function FSArrayBuffer(dataTypeId:String, updateFunc:Function)
		{
			super(dataTypeId, updateFunc);
		}

		override arcanefagal function doBuffer(context3D:Context3D):void
		{
			doUpdateFunc();

			for (var i:int = 0; i < textures.length; i++)
			{
				//从纹理缓存中获取纹理
				var textureBase:TextureBase = TextureCenter.getTexture(context3D, textures[i]);

				context3D.setTextureAt(shaderRegister.index + i, textureBase);
			}
		}

		public function update(textures:Array):void
		{
			this.textures = textures;
		}
	}
}

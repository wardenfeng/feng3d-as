package me.feng3d.core.buffer
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.textures.CubeTexture;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.utils.Dictionary;

	import me.feng3d.textures.BitmapCubeTexture;
	import me.feng3d.textures.BitmapTexture;
	import me.feng3d.textures.RenderTexture;
	import me.feng3d.textures.TextureProxyBase;
	import me.feng3d.utils.MipmapGenerator;

	/**
	 * 纹理缓存中心
	 * @author feng 2014-8-14
	 */
	public class TextureCenter
	{
		/** 纹理字典 */
		private static var textureDic:Dictionary = new Dictionary();

		/**
		 * 创建一个纹理缓存中心
		 */
		public function TextureCenter()
		{
		}

		/**
		 * 获取纹理
		 * @param context3D		3D环境
		 * @param texture		纹理代理
		 * @return				纹理
		 */
		public static function getTexture(context3D:Context3D, texture:TextureProxyBase):TextureBase
		{
			//冲缓存中取纹理
			var textureBase:TextureBase = $getTexture(context3D, texture);
			if (textureBase)
				return textureBase;

			//创建位图纹理
			var bitmapTexture:BitmapTexture = texture as BitmapTexture;
			if (bitmapTexture)
				return createTexture(context3D, bitmapTexture);

			//创建立方体纹理
			var bitmapCubeTexture:BitmapCubeTexture = texture as BitmapCubeTexture;
			if (bitmapCubeTexture)
				return createCubeTexture(context3D, bitmapCubeTexture);

			var renderTexture:RenderTexture = texture as RenderTexture;
			if (renderTexture)
				return createRenderTexture(context3D, renderTexture);

			return null;
		}

		/**
		 * 获取纹理
		 * @param context3D		3D环境
		 * @param texture		纹理代理
		 * @return				纹理
		 */
		private static function $getTexture(context3D:Context3D, texture:TextureProxyBase):TextureBase
		{
			if (textureDic[texture] == null || textureDic[texture][context3D] == null)
			{
				return null;
			}
			return textureDic[texture][context3D];
		}

		/**
		 * 创建纹理
		 * @param context3D				3D环境
		 * @param bitmapTexture			位图纹理代理
		 * @return						纹理
		 */
		private static function createTexture(context3D:Context3D, bitmapTexture:BitmapTexture):TextureBase
		{
			var texture:Texture = context3D.createTexture(bitmapTexture.width, bitmapTexture.height, bitmapTexture.format, true);

			if (bitmapTexture.generateMipmaps)
				MipmapGenerator.generateMipMaps(bitmapTexture.bitmapData, texture, bitmapTexture.mipMapHolder, true);
			else
				texture.uploadFromBitmapData(bitmapTexture.bitmapData, 0);

			saveTextureBuffer(bitmapTexture, context3D, texture);

			return texture;
		}

		/**
		 * 创建纹理
		 * @param context3D				3D环境
		 * @param renderTexture			渲染纹理代理
		 * @return						纹理
		 */
		private static function createRenderTexture(context3D:Context3D, renderTexture:RenderTexture):TextureBase
		{
			var texture:Texture = context3D.createTexture(renderTexture.width, renderTexture.height, renderTexture.format, true);

			var bmp:BitmapData = new BitmapData(renderTexture.width, renderTexture.height, false, 0xff0000);
			MipmapGenerator.generateMipMaps(bmp, texture);
			bmp.dispose();

			saveTextureBuffer(renderTexture, context3D, texture);

			return texture;
		}

		/**
		 * 创建立方体纹理
		 * @param context3D				3D环境
		 * @param bitmapTexture			位图立方体纹理代理
		 * @return						立方体纹理
		 */
		private static function createCubeTexture(context3D:Context3D, bitmapTexture:BitmapCubeTexture):TextureBase
		{
			var texture:CubeTexture = context3D["createCubeTexture"](bitmapTexture.size, bitmapTexture.format, bitmapTexture.optimizeForRenderToTexture, bitmapTexture.streamingLevels);

			var _bitmapDatas:Vector.<BitmapData> = bitmapTexture.bitmapDatas;

			for (var i:int = 0; i < 6; ++i)
				MipmapGenerator.generateMipMaps(_bitmapDatas[i], texture, null, _bitmapDatas[i].transparent, i);

			saveTextureBuffer(bitmapTexture, context3D, texture);

			return texture;
		}

		/**
		 * 保存纹理缓存
		 * @param texture				纹理代理
		 * @param context3D				3D环境
		 * @param textureBase			纹理
		 */
		private static function saveTextureBuffer(texture:TextureProxyBase, context3D:Context3D, textureBase:TextureBase):void
		{
			var textureDic1:Dictionary = textureDic[texture];
			if (textureDic1 == null)
				textureDic1 = textureDic[texture] = new Dictionary();
			textureDic1[context3D] = textureBase;
		}
	}
}

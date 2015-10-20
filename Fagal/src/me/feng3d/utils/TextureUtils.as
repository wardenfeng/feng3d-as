package me.feng3d.utils
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DMipFilter;
	import flash.display3D.Context3DTextureFilter;
	import flash.display3D.Context3DWrapMode;

	import me.feng3d.textures.BitmapCubeTexture;
	import me.feng3d.textures.TextureProxyBase;

	/**
	 * 纹理工具类
	 * @author feng 2015-7-7
	 */
	public class TextureUtils
	{
		/**
		 * 支持的最大纹理尺寸
		 */
		private static const MAX_SIZE:uint = 4096;

		/**
		 * 判断是否为有效位图
		 * @param bitmapData		位图
		 * @return
		 */
		public static function isBitmapDataValid(bitmapData:BitmapData):Boolean
		{
			if (bitmapData == null)
				return true;

			return isDimensionValid(bitmapData.width) && isDimensionValid(bitmapData.height);
		}

		/**
		 * 尺寸是否有效
		 * @param d		尺寸
		 * @return
		 */
		public static function isDimensionValid(d:uint):Boolean
		{
			return d >= 1 && d <= MAX_SIZE && isPowerOfTwo(d);
		}

		/**
		 * 是否为2的指数次方
		 * @param value			被检查的值
		 * @return
		 */
		public static function isPowerOfTwo(value:int):Boolean
		{
			return value ? ((value & -value) == value) : false;
		}

		/**
		 * 转换为最佳2的指数次方值
		 * @param value			尺寸
		 * @return
		 */
		public static function getBestPowerOf2(value:uint):uint
		{
			var p:uint = 1;

			while (p < value)
				p <<= 1;

			if (p > MAX_SIZE)
				p = MAX_SIZE;

			return p;
		}

		/**
		 * 获取纹理取样参数
		 * @param useMipmapping 		是否使用贴图分层细化
		 * @param useSmoothTextures 	是否使用平滑纹理
		 * @param repeatTextures 		是否重复纹理
		 * @param texture 				取样纹理
		 * @param forceWrap 			强制重复纹理参数
		 * @return
		 */
		public static function getFlags(useMipmapping:Boolean, useSmoothTextures:Boolean, repeatTextures:Boolean, texture:TextureProxyBase, forceWrap:String = null):Array
		{
			var flags:Array = [texture.type];

			var enableMipMaps:Boolean = useMipmapping && texture.hasMipMaps;
			if (useSmoothTextures)
			{
				flags.push(Context3DTextureFilter.LINEAR);
				if (enableMipMaps)
					flags.push(Context3DMipFilter.MIPLINEAR);
			}
			else
			{
				flags.push(Context3DTextureFilter.NEAREST);
				if (enableMipMaps)
					flags.push(Context3DMipFilter.MIPNEAREST);
			}

			if (forceWrap)
			{
				flags.push(forceWrap);
			}
			else
			{
				if (!(texture is BitmapCubeTexture))
				{
					if (repeatTextures)
					{
						flags.push(Context3DWrapMode.REPEAT);
					}
					else
					{
						flags.push(Context3DWrapMode.CLAMP);
					}
				}
			}

			return flags;
		}
	}
}

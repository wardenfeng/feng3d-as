package me.feng3d.textures
{
	import flash.display.BitmapData;
	
	import me.feng3d.utils.TextureUtils;

	/**
	 * 位图纹理
	 * @author feng 2014-3-24
	 */
	public class BitmapTexture extends Texture2DBase
	{
		private var _bitmapData:BitmapData;
		private var _mipMapHolder:BitmapData;
		private var _generateMipmaps:Boolean;

		public function BitmapTexture(bitmapData:BitmapData, generateMipmaps:Boolean = true)
		{
			super();
			this.bitmapData = bitmapData;
			_generateMipmaps = generateMipmaps;
		}

		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		public function set bitmapData(value:BitmapData):void
		{
			if (value == _bitmapData)
				return;
			
			if (!TextureUtils.isBitmapDataValid(value))
				throw new Error("Invalid bitmapData: Width and height must be power of 2 and cannot exceed 2048");
			
			invalidateContent();
			setSize(value.width, value.height);
			
			_bitmapData = value;
		}

		public function get generateMipmaps():Boolean
		{
			return _generateMipmaps;
		}

		public function set generateMipmaps(value:Boolean):void
		{
			_generateMipmaps = value;
		}

		public function get mipMapHolder():BitmapData
		{
			return _mipMapHolder;
		}

		public function set mipMapHolder(value:BitmapData):void
		{
			_mipMapHolder = value;
		}


	}
}

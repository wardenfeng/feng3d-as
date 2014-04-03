package feng3d.textures
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix;

	/**
	 * 位图纹理
	 * @author warden_feng 2014-3-24
	 */
	public class BitmapTexture
	{
		public var _bitmapData:BitmapData;

		private var _texture:Texture;

		protected var _dirty:Context3D;

		public function BitmapTexture(bitmapData:BitmapData, generateMipmaps:Boolean = true)
		{
			this._bitmapData = bitmapData;
		}

		public static function uploadTextureWithMipmaps(dest:Texture, src:BitmapData):void
		{
			var ws:int = src.width;
			var hs:int = src.height;
			var level:int = 0;
			var tmp:BitmapData;
			var transform:Matrix = new Matrix();
			var tmp2:BitmapData;

			tmp = new BitmapData(src.width, src.height, true, 0x00000000);

			while (ws >= 1 && hs >= 1)
			{
				tmp.draw(src, transform, null, null, null, true);
				dest.uploadFromBitmapData(tmp, level);
				transform.scale(0.5, 0.5);
				level++;
				ws >>= 1;
				hs >>= 1;
				if (hs && ws)
				{
					tmp.dispose();
					tmp = new BitmapData(ws, hs, true, 0x00000000);
				}
			}
			tmp.dispose();
		}

		public function getTextureForContext3D(context:Context3D):TextureBase
		{
			if (_dirty == null && _bitmapData != null)
			{
				_texture = context.createTexture(_bitmapData.width, _bitmapData.height, Context3DTextureFormat.BGRA, false);
				_dirty = context;
				uploadTextureWithMipmaps(_texture, _bitmapData);
			}
			return _texture;
		}
	}
}

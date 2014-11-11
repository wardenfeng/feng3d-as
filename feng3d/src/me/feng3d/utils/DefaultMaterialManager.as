package me.feng3d.utils
{
	import flash.display.BitmapData;
	
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.textures.BitmapTexture;
	
	public class DefaultMaterialManager
	{
		private static var _defaultTextureBitmapData:BitmapData;
		private static var _defaultMaterial:TextureMaterial;
		private static var _defaultTexture:BitmapTexture;
		
		public static function getDefaultMaterial():TextureMaterial
		{
			if (!_defaultTexture)
				createDefaultTexture();
			
			if (!_defaultMaterial)
				createDefaultMaterial();
			
			return _defaultMaterial;
		}
		
		public static function getDefaultTexture():BitmapTexture
		{
			if (!_defaultTexture)
				createDefaultTexture();
			
			return _defaultTexture;
		}
		
		private static function createDefaultTexture(color:uint = 0XFFFFFF):void
		{
			_defaultTextureBitmapData = new BitmapData(8, 8, false, 0x0);
			
			//create chekerboard
			var i:uint, j:uint;
			for (i = 0; i < 8; i++) {
				for (j = 0; j < 8; j++) {
					if ((j & 1) ^ (i & 1))
						_defaultTextureBitmapData.setPixel(i, j, 0XFFFFFF);
				}
			}
			
			_defaultTexture = new BitmapTexture(_defaultTextureBitmapData);
		}
		
		private static function createDefaultMaterial():void
		{
			_defaultMaterial = new TextureMaterial(_defaultTexture);
			_defaultMaterial.mipmap = false;
			_defaultMaterial.smooth = false;
		}
	}
}

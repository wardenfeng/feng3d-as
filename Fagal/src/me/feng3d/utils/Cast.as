package me.feng3d.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	import me.feng3d.textures.BitmapTexture;

	/**
	 * 资源处理
	 * @author warden_feng 2014-3-24
	 */
	public class Cast
	{
		private static var _notClasses:Dictionary = new Dictionary();
		private static var _classes:Dictionary = new Dictionary();

		/**
		 * 获取类定义
		 * @param name		类描述字符串
		 * @return			类定义
		 */
		public static function tryClass(name:String):Object
		{
			if (_notClasses[name])
				return name;

			var result:Class = _classes[name];

			if (result != null)
				return result;

			try
			{
				result = getDefinitionByName(name) as Class;
				_classes[name] = result;
				return result;
			}
			catch (error:ReferenceError)
			{
			}

			_notClasses[name] = true;

			return name;
		}

		/**
		 * 转换位图数据
		 * @param data		位图数据
		 * @return 			位图数据
		 */
		public static function bitmapData(data:*):BitmapData
		{
			if (data == null)
				return null;

			if (data is String)
				data = tryClass(data);

			if (data is Class)
			{
				try
				{
					data = new data;
				}
				catch (bitmapError:ArgumentError)
				{
					data = new data(0, 0);
				}
			}

			if (data is BitmapData)
				return data;

			if (data is Bitmap)
			{
				if ((data as Bitmap).hasOwnProperty("bitmapData")) // if (data is BitmapAsset)
					return (data as Bitmap).bitmapData;
			}

			if (data is DisplayObject)
			{
				var ds:DisplayObject = data as DisplayObject;
				var bmd:BitmapData = new BitmapData(ds.width, ds.height, true, 0x00FFFFFF);
				var mat:Matrix = ds.transform.matrix.clone();
				mat.tx = 0;
				mat.ty = 0;
				bmd.draw(ds, mat, ds.transform.colorTransform, ds.blendMode, bmd.rect, true);
				return bmd;
			}

			throw new Error("Can't cast to BitmapData: " + data);
		}

		/**
		 * 转换位图纹理
		 * @param data		位图数据
		 * @return 			位图纹理
		 */
		public static function bitmapTexture(data:*):BitmapTexture
		{
			if (data == null)
				return null;

			if (data is String)
				data = tryClass(data);

			if (data is Class)
			{
				try
				{
					data = new data;
				}
				catch (materialError:ArgumentError)
				{
					data = new data(0, 0);
				}
			}

			if (data is Texture)
				return data;

			try
			{
				var bmd:BitmapData = Cast.bitmapData(data);
				return new BitmapTexture(bmd);
			}
			catch (error:Error)
			{
			}

			throw new Error("Can't cast to BitmapTexture: " + data);
		}
	}
}

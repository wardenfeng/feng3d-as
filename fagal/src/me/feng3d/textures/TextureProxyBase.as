package me.feng3d.textures
{

	import flash.display3D.Context3DTextureFormat;
	
	import me.feng.component.Component;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.library.assets.NamedAsset;

	/**
	 * 纹理代理基类
	 * <p>处理纹理与stage3d的关系</p>
	 * @author feng 2014-4-15
	 */
	public class TextureProxyBase extends Component implements IAsset
	{
		private var _namedAsset:NamedAsset;
		/** 纹理类型 */
		public var type:String;

		/**
		 * 纹理格式
		 */
		protected var _format:String = Context3DTextureFormat.BGRA;

		/**
		 * 是否有miplevel
		 */
		protected var _hasMipmaps:Boolean = true;

		/**
		 * 纹理宽度
		 */
		protected var _width:int;

		/**
		 * 纹理高度
		 */
		protected var _height:int;

		/**
		 * 创建一个纹理代理基类
		 */
		public function TextureProxyBase()
		{
			_namedAsset = new NamedAsset(this,AssetType.TEXTURE);
		}

		/**
		 * 是否有miplevel
		 */
		public function get hasMipMaps():Boolean
		{
			return _hasMipmaps;
		}

		/**
		 * 纹理格式
		 * @see flash.display3D.Context3DTextureFormat
		 */
		public function get format():String
		{
			return _format;
		}

		/**
		 * 纹理宽度
		 */
		public function get width():int
		{
			return _width;
		}

		/**
		 * 纹理高度
		 */
		public function get height():int
		{
			return _height;
		}

		/**
		 * 设置纹理尺寸
		 * @param width		纹理宽度
		 * @param height	纹理高度
		 */
		protected function setSize(width:int, height:int):void
		{
			if (_width != width || _height != height)
				invalidateSize();

			_width = width;
			_height = height;
		}

		/**
		 * 尺寸失效
		 */
		protected function invalidateSize():void
		{
		}

		/**
		 * 纹理失效
		 */
		public function invalidateContent():void
		{

		}
		
		public function get namedAsset():NamedAsset
		{
			return _namedAsset;
		}
	}
}

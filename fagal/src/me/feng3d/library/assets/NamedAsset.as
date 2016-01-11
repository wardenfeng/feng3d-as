package me.feng3d.library.assets
{
	import flash.utils.Dictionary;
	
	import me.feng.arcaneCommon;
	import me.feng.utils.ClassUtils;

	use namespace arcaneCommon;
	
	/**
	 * 拥有名字的对象
	 * @author feng 2014-5-7
	 */
	public class NamedAsset
	{
		private static const nameDic:Dictionary = new Dictionary();

		private var _asset:IAsset;
		arcaneCommon var _assetType:String;
		private var _name:String;
		/**
		 * 创建一个拥有名字的对象
		 */
		public function NamedAsset(asset:IAsset,assetType:String)
		{
			super();
			_asset = asset;
			_assetType = assetType;
		}

		/**
		 * 名称
		 */
		public function get name():String
		{
			if (!_name)
			{
				var defaultName:String = ClassUtils.getDefaultName(this);
				_name = defaultName + int(nameDic[defaultName]);
				nameDic[defaultName] = int(nameDic[defaultName]) + 1;
			}
			return _name;
		}

		public function set name(value:String):void
		{
//			if (_name)
//				throw new Error(getQualifiedClassName(this) + " -- 对象已经有名称，无法更改");
			_name = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get assetType():String
		{
			return _assetType;
		}
		
	}
}

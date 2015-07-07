package me.feng3d.parsers
{
	import flash.net.URLRequest;
	
	import me.feng3d.arcane;
	import me.feng3d.library.assets.IAsset;

	use namespace arcane;

	/**
	 * 资源依赖(包含需要加载与处理的资源)
	 * @author warden_feng 2014-5-19
	 */
	public class ResourceDependency
	{
		private var _id:String;
		private var _req:URLRequest;
		private var _assets:Vector.<IAsset>;
		private var _parentParser:ParserBase;
		private var _data:*;
		private var _retrieveAsRawData:Boolean;
		private var _suppressAssetEvents:Boolean;
		private var _dependencies:Vector.<ResourceDependency>;

		arcane var success:Boolean;

		/**
		 * 创建资源依赖
		 * @param id 编号
		 * @param req url请求
		 * @param data 数据
		 * @param parentParser 被依赖的解析者
		 * @param retrieveAsRawData
		 * @param suppressAssetEvents
		 */		
		public function ResourceDependency(id:String, req:URLRequest, data:*, parentParser:ParserBase, retrieveAsRawData:Boolean = false, suppressAssetEvents:Boolean = false)
		{
			_id = id;
			_req = req;
			_parentParser = parentParser;
			_data = data;
			_retrieveAsRawData = retrieveAsRawData;
			_suppressAssetEvents = suppressAssetEvents;

			_assets = new Vector.<IAsset>();
			_dependencies = new Vector.<ResourceDependency>();
		}

		public function get id():String
		{
			return _id;
		}

		public function get assets():Vector.<IAsset>
		{
			return _assets;
		}

		public function get dependencies():Vector.<ResourceDependency>
		{
			return _dependencies;
		}

		public function get request():URLRequest
		{
			return _req;
		}

		public function get retrieveAsRawData():Boolean
		{
			return _retrieveAsRawData;
		}

		public function get suppresAssetEvents():Boolean
		{
			return _suppressAssetEvents;
		}

		public function get data():*
		{
			return _data;
		}

		arcane function setData(data:*):void
		{
			_data = data;
		}

		/**
		 * 被依赖的解析者
		 */
		public function get parentParser():ParserBase
		{
			return _parentParser;
		}

		/**
		 * 解决依赖
		 */
		public function resolve():void
		{
			if (_parentParser)
				_parentParser.resolveDependency(this);
		}

		/**
		 * 解决失败
		 */
		public function resolveFailure():void
		{
			if (_parentParser)
				_parentParser.resolveDependencyFailure(this);
		}

		/**
		 * 解决资源的名称
		 */
		public function resolveName(asset:IAsset):String
		{
			if (_parentParser)
				return _parentParser.resolveDependencyName(this, asset);
			return asset.name;
		}

	}
}

package me.feng3d.parsers
{
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	import me.feng.error.AbstractClassError;
	import me.feng.error.AbstractMethodError;
	import me.feng.events.FEventDispatcher;
	import me.feng3d.arcane;
	import me.feng3d.events.AssetEvent;
	import me.feng3d.events.ParserEvent;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.parsers.utils.ParserUtil;

	use namespace arcane;

	/**
	 * 解析基类
	 * @author feng 2014-5-16
	 */
	public class ParserBase extends FEventDispatcher
	{
		protected static const PARSING_DONE:Boolean = true;
		protected static const MORE_TO_PARSE:Boolean = false;

		arcane var _fileName:String;

		protected var _dataFormat:String;
		protected var _data:*;
		protected var _frameLimit:Number;
		protected var _lastFrameTime:Number;

		/** 依赖资源列表 */
		private var _dependencies:Vector.<ResourceDependency>;
		private var _parsingPaused:Boolean;
		private var _parsingComplete:Boolean;
		/** 是否解析失败 */
		private var _parsingFailure:Boolean;
		private var _timer:Timer;
		/**  */
		private var _materialMode:uint;

		public function ParserBase(format:String)
		{
			_materialMode = 0;
			_dataFormat = format;
			_dependencies = new Vector.<ResourceDependency>();
			AbstractClassError.check(this);
		}

		protected function getTextData():String
		{
			return ParserUtil.toString(_data);
		}

		protected function getByteData():ByteArray
		{
			return ParserUtil.toByteArray(_data);
		}

		public function set materialMode(newMaterialMode:uint):void
		{
			_materialMode = newMaterialMode;
		}

		public function get materialMode():uint
		{
			return _materialMode;
		}

		/** 数据格式 */
		public function get dataFormat():String
		{
			return _dataFormat;
		}

		/**
		 * 完成资源分析（派发资源事件）
		 * @param asset 完成的资源
		 * @param name 资源名称
		 */
		protected function finalizeAsset(asset:IAsset, name:String = null):void
		{
			var type_event:String;
			var type_name:String;

			if (name != null)
				asset.name = name;

			switch (asset.assetType)
			{
				case AssetType.LIGHT_PICKER:
					type_name = 'lightPicker';
					type_event = AssetEvent.LIGHTPICKER_COMPLETE;
					break;
				case AssetType.LIGHT:
					type_name = 'light';
					type_event = AssetEvent.LIGHT_COMPLETE;
					break;
				case AssetType.ANIMATOR:
					type_name = 'animator';
					type_event = AssetEvent.ANIMATOR_COMPLETE;
					break;
				case AssetType.ANIMATION_SET:
					type_name = 'animationSet';
					type_event = AssetEvent.ANIMATION_SET_COMPLETE;
					break;
				case AssetType.ANIMATION_STATE:
					type_name = 'animationState';
					type_event = AssetEvent.ANIMATION_STATE_COMPLETE;
					break;
				case AssetType.ANIMATION_NODE:
					type_name = 'animationNode';
					type_event = AssetEvent.ANIMATION_NODE_COMPLETE;
					break;
				case AssetType.STATE_TRANSITION:
					type_name = 'stateTransition';
					type_event = AssetEvent.STATE_TRANSITION_COMPLETE;
					break;
				case AssetType.TEXTURE:
					type_name = 'texture';
					type_event = AssetEvent.TEXTURE_COMPLETE;
					break;
				case AssetType.TEXTURE_PROJECTOR:
					type_name = 'textureProjector';
					type_event = AssetEvent.TEXTURE_PROJECTOR_COMPLETE;
					break;
				case AssetType.CONTAINER:
					type_name = 'container';
					type_event = AssetEvent.CONTAINER_COMPLETE;
					break;
				case AssetType.GEOMETRY:
					type_name = 'geometry';
					type_event = AssetEvent.GEOMETRY_COMPLETE;
					break;
				case AssetType.MATERIAL:
					type_name = 'material';
					type_event = AssetEvent.MATERIAL_COMPLETE;
					break;
				case AssetType.MESH:
					type_name = 'mesh';
					type_event = AssetEvent.MESH_COMPLETE;
					break;
				case AssetType.SKELETON:
					type_name = 'skeleton';
					type_event = AssetEvent.SKELETON_COMPLETE;
					break;
				case AssetType.SKELETON_POSE:
					type_name = 'skelpose';
					type_event = AssetEvent.SKELETON_POSE_COMPLETE;
					break;
				case AssetType.ENTITY:
					type_name = 'entity';
					type_event = AssetEvent.ENTITY_COMPLETE;
					break;
				case AssetType.SKYBOX:
					type_name = 'skybox';
					type_event = AssetEvent.SKYBOX_COMPLETE;
					break;
				case AssetType.CAMERA:
					type_name = 'camera';
					type_event = AssetEvent.CAMERA_COMPLETE;
					break;
				case AssetType.SEGMENT_SET:
					type_name = 'segmentSet';
					type_event = AssetEvent.SEGMENT_SET_COMPLETE;
					break;
				case AssetType.EFFECTS_METHOD:
					type_name = 'effectsMethod';
					type_event = AssetEvent.EFFECTMETHOD_COMPLETE;
					break;
				case AssetType.SHADOW_MAP_METHOD:
					type_name = 'effectsMethod';
					type_event = AssetEvent.SHADOWMAPMETHOD_COMPLETE;
					break;
				default:
					throw new Error('Unhandled asset type ' + asset.assetType + '. Report as bug!');
					break;
			}

			//默认资源名为类型名
			if (!asset.name)
				asset.name = type_name;

			dispatchEvent(new AssetEvent(AssetEvent.ASSET_COMPLETE, asset));
			dispatchEvent(new AssetEvent(type_event, asset));
		}

		/**
		 * 解决依赖
		 * @param resourceDependency 依赖资源
		 */
		arcane function resolveDependency(resourceDependency:ResourceDependency):void
		{
			throw new AbstractMethodError();
		}

		/**
		 * 解决依赖失败
		 * @param resourceDependency 依赖资源
		 */
		arcane function resolveDependencyFailure(resourceDependency:ResourceDependency):void
		{
			throw new AbstractMethodError();
		}

		arcane function resolveDependencyName(resourceDependency:ResourceDependency, asset:IAsset):String
		{
			return asset.name;
		}

		/**
		 * 是否在解析中
		 */
		protected function proceedParsing():Boolean
		{
			throw new AbstractMethodError();
		}

		/**
		 * 是否暂停解析
		 */
		public function get parsingPaused():Boolean
		{
			return _parsingPaused;
		}

		/**
		 * 是否解析完成
		 */
		public function get parsingComplete():Boolean
		{
			return _parsingComplete;
		}

		/**
		 * 异步解析数据
		 * @param data 数据
		 * @param frameLimit 帧时间限制
		 */
		public function parseAsync(data:*, frameLimit:Number = 30):void
		{
			_data = data;
			startParsing(frameLimit);
		}

		/**
		 * A list of dependencies that need to be loaded and resolved for the object being parsed.
		 */
		public function get dependencies():Vector.<ResourceDependency>
		{
			return _dependencies;
		}

		/**
		 * 是否还有时间
		 */
		protected function hasTime():Boolean
		{
			return ((getTimer() - _lastFrameTime) < _frameLimit);
		}

		/**
		 * 开始解析数据
		 * @param frameLimit 帧时间限制
		 */
		protected function startParsing(frameLimit:Number):void
		{
			_frameLimit = frameLimit;
			_timer = new Timer(_frameLimit, 0);
			_timer.addEventListener(TimerEvent.TIMER, onInterval);
			_timer.start();
		}

		/**
		 * 触发解析
		 * @param event
		 */
		protected function onInterval(event:TimerEvent = null):void
		{
			_lastFrameTime = getTimer();
			if (proceedParsing() && !_parsingFailure)
				finishParsing();
		}

		/**
		 * 暂停解析，去准备依赖项
		 */
		protected function pauseAndRetrieveDependencies():void
		{
//			if (_timer)
//				_timer.stop();
//			_parsingPaused = true;
//			dispatchEvent(new ParserEvent(ParserEvent.READY_FOR_DEPENDENCIES));
		}

		/**
		 * 继续解析，准备好依赖项后
		 */
		arcane function resumeParsingAfterDependencies():void
		{
			_parsingPaused = false;
			if (_timer)
				_timer.start();
		}

		/**
		 * 完成解析
		 */
		protected function finishParsing():void
		{
			if (_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, onInterval);
				_timer.stop();
			}
			_timer = null;
			_parsingComplete = true;
			dispatchEvent(new ParserEvent(ParserEvent.PARSE_COMPLETE));
		}

		/**
		 * 添加依赖项
		 * @param id 编号
		 * @param req url请求
		 * @param retrieveAsRawData
		 * @param data
		 * @param suppressErrorEvents
		 */
		protected function addDependency(id:String, req:URLRequest, retrieveAsRawData:Boolean = false, data:* = null, suppressErrorEvents:Boolean = false):void
		{
			_dependencies.push(new ResourceDependency(id, req, data, this, retrieveAsRawData, suppressErrorEvents));
		}

	}
}

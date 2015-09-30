package me.feng3d.materials
{
	import flash.display.BlendMode;
	import flash.events.Event;

	import me.feng.core.NamedAssetBase;
	import me.feng3d.arcane;
	import me.feng3d.animators.IAnimationSet;
	import me.feng3d.core.base.IMaterialOwner;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.materials.lightpickers.LightPickerBase;
	import me.feng3d.passes.DepthMapPass;
	import me.feng3d.passes.MaterialPassBase;
	import me.feng3d.passes.PlanarShadowPass;

	use namespace arcane;

	/**
	 * 材质基类
	 * @author warden_feng 2014-4-15
	 */
	public class MaterialBase extends NamedAssetBase implements IAsset
	{
		/**
		 * 唯一编号
		 */
		arcane var _uniqueId:uint;

		/**
		 * 渲染序列编号
		 */
		arcane var _renderOrderId:int;

		private var _bothSides:Boolean;

		private var _owners:Vector.<IMaterialOwner>;

		private var _alphaPremultiplied:Boolean;

		private var _blendMode:String = BlendMode.NORMAL;

		protected var _numPasses:uint;

		protected var _mipmap:Boolean = true;
		protected var _smooth:Boolean = true;
		protected var _repeat:Boolean;

		protected var _passes:Vector.<MaterialPassBase>;

		protected var _depthPass:DepthMapPass;
		protected var _planarShadowPass:PlanarShadowPass;

		protected var _lightPicker:LightPickerBase;

		/**
		 * 创建一个材质基类
		 */
		public function MaterialBase()
		{
			_owners = new Vector.<IMaterialOwner>();
			_passes = new Vector.<MaterialPassBase>();
			_depthPass = new DepthMapPass();
			_planarShadowPass = new PlanarShadowPass();

			// Default to considering pre-multiplied textures while blending
			alphaPremultiplied = true;
		}

		/**
		 * 深度渲染通道
		 */
		public function get depthPass():DepthMapPass
		{
			return _depthPass;
		}

		/**
		 * 平面阴影映射通道
		 */
		public function get planarShadowPass():PlanarShadowPass
		{
			return _planarShadowPass;
		}

		/**
		 * 是否双面渲染
		 */
		public function get bothSides():Boolean
		{
			return _bothSides;
		}

		public function set bothSides(value:Boolean):void
		{
			_bothSides = value;

			for (var i:int = 0; i < _numPasses; ++i)
				_passes[i].bothSides = value;
		}

		/**
		 * 是否需要混合
		 */
		public function get requiresBlending():Boolean
		{
			return _blendMode != BlendMode.NORMAL;
		}

		/**
		 * 混合模式
		 */
		public function get blendMode():String
		{
			return _blendMode;
		}

		public function set blendMode(value:String):void
		{
			_blendMode = value;
		}

		/**
		 * Indicates whether visible textures (or other pixels) used by this material have
		 * already been premultiplied. Toggle this if you are seeing black halos around your
		 * blended alpha edges.
		 */
		public function get alphaPremultiplied():Boolean
		{
			return _alphaPremultiplied;
		}

		public function set alphaPremultiplied(value:Boolean):void
		{
			_alphaPremultiplied = value;

			for (var i:int = 0; i < _numPasses; ++i)
				_passes[i].alphaPremultiplied = value;
		}

		/**
		 * 是否使用纹理分级细化
		 */
		public function get mipmap():Boolean
		{
			return _mipmap;
		}

		public function set mipmap(value:Boolean):void
		{
			_mipmap = value;
			for each (var pass:MaterialPassBase in _passes)
			{
				pass.mipmap = value;
			}
		}

		/**
		 * 是否重复
		 */
		public function get repeat():Boolean
		{
			return _repeat;
		}

		public function set repeat(value:Boolean):void
		{
			_repeat = value;
			for each (var pass:MaterialPassBase in _passes)
			{
				pass.repeat = value;
			}
		}

		/**
		 * 是否平滑
		 */
		public function get smooth():Boolean
		{
			return _smooth;
		}

		public function set smooth(value:Boolean):void
		{
			_smooth = value;
			for each (var pass:MaterialPassBase in _passes)
			{
				pass.smooth = value;
			}
		}

		/**
		 * 添加通道
		 * @param pass 通道
		 */
		protected function addPass(pass:MaterialPassBase):void
		{
			_passes.push(pass);
			_numPasses = _passes.length;

			pass.alphaPremultiplied = _alphaPremultiplied;

			pass.mipmap = _mipmap;
			pass.smooth = _smooth;
			pass.repeat = _repeat;
			pass.bothSides = _bothSides;
			pass.addEventListener(Event.CHANGE, onPassChange);
			invalidatePasses(null);
		}

		/**
		 * 获取渲染通道
		 * @param index		渲染通道索引
		 * @return			返回指定索引处渲染通道
		 */
		public function getPass(index:int):MaterialPassBase
		{
			return _passes[index];
		}

		/**
		 * 处理通道变化事件
		 */
		private function onPassChange(event:Event):void
		{

		}

		/**
		 * 移除通道
		 * @param pass 通道
		 */
		protected function removePass(pass:MaterialPassBase):void
		{
			_passes.splice(_passes.indexOf(pass), 1);
		}

		/**
		 * 动画集合
		 */
		public function set animationSet(value:IAnimationSet):void
		{
			for each (var pass:MaterialPassBase in _passes)
			{
				pass.animationSet = value;
			}
			depthPass.animationSet = value;
			planarShadowPass.animationSet = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get assetType():String
		{
			return AssetType.MATERIAL;
		}

		/**
		 * 灯光采集器
		 */
		public function get lightPicker():LightPickerBase
		{
			return _lightPicker;
		}

		public function set lightPicker(value:LightPickerBase):void
		{
			if (value != _lightPicker)
			{
				_lightPicker = value;
				var len:uint = _passes.length;
				for (var i:uint = 0; i < len; ++i)
					_passes[i].lightPicker = _lightPicker;
			}
		}

		/**
		 * 通道失效
		 */
		arcane function invalidatePasses(triggerPass:MaterialPassBase):void
		{
			for each (var pass:MaterialPassBase in _passes)
			{
				if (pass != triggerPass)
					pass.invalidateShaderProgram();
			}
		}

		/**
		 * 渲染通道数量
		 */
		arcane function get numPasses():uint
		{
			return _numPasses;
		}

		/**
		 * 更新材质
		 */
		arcane function updateMaterial():void
		{

		}

		/**
		 * 清除通道渲染状态
		 * @param index				通道索引
		 * @param stage3DProxy		3D舞台代理
		 */
		arcane function deactivatePass(index:uint):void
		{
			_passes[index].deactivate();
		}

		/**
		 * 停用材质的最后一个通道
		 */
		arcane function deactivate():void
		{
			_passes[_numPasses - 1].deactivate();
		}

		/**
		 * 添加材质拥有者
		 * @param owner		材质拥有者
		 */
		arcane function addOwner(owner:IMaterialOwner):void
		{
			_owners.push(owner);
		}

		/**
		 * 移除材质拥有者
		 * @param owner		材质拥有者
		 */
		arcane function removeOwner(owner:IMaterialOwner):void
		{
			_owners.splice(_owners.indexOf(owner), 1);
			if (_owners.length == 0)
			{
				invalidatePasses(null);
			}
		}
	}
}

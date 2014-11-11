package me.feng3d.materials
{
	import flash.display.BlendMode;
	
	import me.feng3d.arcane;
	import me.feng3d.animators.AnimationSet;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.IRenderable;
	import me.feng3d.core.proxy.Context3DCache;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.events.MaterialEvent;
	import me.feng3d.fagal.ShaderParams;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.library.assets.NamedAssetBase;
	import me.feng3d.materials.lightpickers.LightPickerBase;
	import me.feng3d.passes.MaterialPassBase;

	use namespace arcane;

	/**
	 * 材质基类
	 * @author warden_feng 2014-4-15
	 */
	public class MaterialBase extends NamedAssetBase implements IAsset
	{
		private var _bothSides:Boolean;
		private var _blendMode:String = BlendMode.NORMAL;

		protected var _mipmap:Boolean = true;
		protected var _smooth:Boolean = true;
		protected var _repeat:Boolean;

		protected var _numPasses:uint;
		protected var _passes:Vector.<MaterialPassBase>;

		protected var _lightPicker:LightPickerBase;
		
		public function MaterialBase()
		{
			_passes = new Vector.<MaterialPassBase>();
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
		 * 激活通道
		 * @param shaderParams 渲染参数
		 * @param stage3DProxy 
		 * @param camera
		 */		
		arcane function activatePass(shaderParams:ShaderParams, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			for (var i:int = 0; i < _numPasses; i++)
			{
				var pass:MaterialPassBase = _passes[i];
				
				pass.activate(shaderParams, stage3DProxy, camera);
			}
		}
		
		/**
		 * 渲染通道
		 * @param renderable 可渲染对象
		 * @param stage3DProxy stage3d代理
		 * @param camera 照相机
		 */		
		arcane function renderPass(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			for (var i:int = 0; i < _numPasses; i++)
			{
				var pass:MaterialPassBase = _passes[i];

				if (renderable.animator)
					pass.updateAnimationState(renderable, stage3DProxy, camera);

				pass.render(renderable, stage3DProxy, camera);
			}
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
			for (var i:int = 0; i < _numPasses; ++i)
				_passes[i].mipmap = value;
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
			for (var i:int = 0; i < _numPasses; ++i)
				_passes[i].repeat = value;
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
			for (var i:int = 0; i < _numPasses; ++i)
				_passes[i].smooth = value;
		}

		/**
		 * 添加通道
		 * @param pass 通道
		 */
		protected function addPass(pass:MaterialPassBase):void
		{
			_passes[_numPasses++] = pass;
			pass.bothSides = _bothSides;
			dispatchEvent(new MaterialEvent(MaterialEvent.PASS_ADDED, pass));
		}

		/**
		 * 移除通道
		 * @param pass 通道
		 */		
		protected function removePass(pass:MaterialPassBase):void
		{
			_passes.splice(_passes.indexOf(pass), 1);
			--_numPasses;
			dispatchEvent(new MaterialEvent(MaterialEvent.PASS_REMOVED, pass));
		}

		public function set animationSet(value:AnimationSet):void
		{
			for (var i:int = 0; i < _numPasses; ++i)
				_passes[i].animationSet = value;
		}

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
			if (value != _lightPicker) {
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
			for (var i:int = 0; i < _numPasses; ++i)
			{
				if (_passes[i] != triggerPass)
					_passes[i].invalidateShaderProgram();
			}
		}

		/**
		 * 收集渲染数据缓冲
		 * @param context3dCache 渲染数据缓冲
		 */
		public function collectCache(context3dCache:Context3DCache):void
		{
			for (var i:int = 0; i < _numPasses; ++i)
			{
				_passes[i].collectCache(context3dCache);
			}
		}

		/**
		 * 释放渲染数据缓冲
		 * @param context3dCache 渲染数据缓冲
		 */		
		public function releaseCache(context3dCache:Context3DCache):void
		{
			for (var i:int = 0; i < _numPasses; ++i)
			{
				_passes[i].releaseCache(context3dCache);
			}
		}
	}
}

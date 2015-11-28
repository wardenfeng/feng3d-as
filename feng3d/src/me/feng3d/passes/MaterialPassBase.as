package me.feng3d.passes
{
	import flash.display.BlendMode;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.Event;

	import me.feng.error.AbstractClassError;
	import me.feng3d.arcane;
	import me.feng3d.animators.IAnimationSet;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.Context3DCache;
	import me.feng3d.core.buffer.context3d.BlendFactorsBuffer;
	import me.feng3d.core.buffer.context3d.CullingBuffer;
	import me.feng3d.core.buffer.context3d.DepthTestBuffer;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.fagal.fragment.F_Main;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.vertex.V_Main;
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.fagalRE.FagalShaderResult;
	import me.feng3d.materials.MaterialBase;
	import me.feng3d.materials.lightpickers.LightPickerBase;
	import me.feng3d.materials.methods.ShaderMethodSetup;
	import me.feng3d.textures.TextureProxyBase;

	use namespace arcane;

	/**
	 * 纹理通道基类
	 * <p>该类实现了生成与管理渲染程序功能</p>
	 * @author feng 2014-4-15
	 */
	public class MaterialPassBase extends Context3DBufferOwner
	{
		protected var _material:MaterialBase;

		protected var _animationSet:IAnimationSet;

		protected var _methodSetup:ShaderMethodSetup;

		protected var _blendFactorSource:String = Context3DBlendFactor.ONE;
		protected var _blendFactorDest:String = Context3DBlendFactor.ZERO;

		protected var _depthCompareMode:String = Context3DCompareMode.LESS_EQUAL;
		protected var _enableBlending:Boolean;

		private var _bothSides:Boolean;

		protected var _lightPicker:LightPickerBase;

		protected var _defaultCulling:String = Context3DTriangleFace.BACK;

		protected var _writeDepth:Boolean = true;

		protected var _smooth:Boolean = true;
		protected var _repeat:Boolean = false;
		protected var _mipmap:Boolean = true;

		protected var _numDirectionalLights:uint;

		protected var _numPointLights:uint;

		protected var _alphaPremultiplied:Boolean;

		private var _shaderParams:ShaderParams;

		/**
		 * 创建一个纹理通道基类
		 */
		public function MaterialPassBase()
		{
			AbstractClassError.check(this);
		}

		/**
		 * The material to which this pass belongs.
		 */
		public function get material():MaterialBase
		{
			return _material;
		}

		public function set material(value:MaterialBase):void
		{
			_material = value;
		}

		/**
		 * 渲染参数
		 */
		public function get shaderParams():ShaderParams
		{
			return _shaderParams ||= new ShaderParams();
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
			if (_smooth == value)
				return;
			_smooth = value;
			invalidateShaderProgram();
		}

		/**
		 * 是否重复平铺
		 */
		public function get repeat():Boolean
		{
			return _repeat;
		}

		public function set repeat(value:Boolean):void
		{
			if (_repeat == value)
				return;
			_repeat = value;
			invalidateShaderProgram();
		}

		/**
		 * 贴图是否使用分级细化
		 */
		public function get mipmap():Boolean
		{
			return _mipmap;
		}

		public function set mipmap(value:Boolean):void
		{
			if (_mipmap == value)
				return;
			_mipmap = value;
			invalidateShaderProgram();
		}

		/**
		 * 是否开启混合模式
		 */
		public function get enableBlending():Boolean
		{
			return _enableBlending;
		}

		public function set enableBlending(value:Boolean):void
		{
			_enableBlending = value;
			markBufferDirty(_.blendFactors);
			markBufferDirty(_.depthTest);
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.culling, updateCullingBuffer);
			mapContext3DBuffer(_.blendFactors, updateBlendFactorsBuffer);
			mapContext3DBuffer(_.depthTest, updateDepthTestBuffer);
			mapContext3DBuffer(_.program, updateProgramBuffer);
		}

		/**
		 * 动画数据集合
		 */
		public function get animationSet():IAnimationSet
		{
			return _animationSet;
		}

		public function set animationSet(value:IAnimationSet):void
		{
			if (_animationSet == value)
				return;

			_animationSet = value;

			invalidateShaderProgram();
		}

		/**
		 * 激活渲染通道
		 * @param shaderParams		渲染参数
		 * @param stage3DProxy		3D舞台代理
		 * @param camera			摄像机
		 */
		arcane function activate(camera:Camera3D, target:TextureProxyBase = null):void
		{
			shaderParams.useMipmapping = _mipmap;
			shaderParams.useSmoothTextures = _smooth;
			shaderParams.repeatTextures = _repeat;

			shaderParams.alphaPremultiplied = _alphaPremultiplied && _enableBlending;

			if (_animationSet)
				_animationSet.activate(shaderParams, this);
		}

		/**
		 * 清除通道渲染数据
		 * @param stage3DProxy		3D舞台代理
		 */
		arcane function deactivate():void
		{
		}

		/**
		 * 更新动画状态
		 * @param renderable			渲染对象
		 * @param stage3DProxy			3D舞台代理
		 * @param camera				摄像机
		 */
		arcane function updateAnimationState(renderable:IRenderable, camera:Camera3D):void
		{
			renderable.animator.setRenderState(renderable, camera);
		}

		/**
		 * 渲染
		 * @param renderable			渲染对象
		 * @param stage3DProxy			3D舞台代理
		 * @param camera				摄像机
		 * @param renderIndex			渲染编号
		 */
		arcane function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, renderIndex:int):void
		{
			updateConstantData(renderable, camera);

			var context3dCache:Context3DCache = renderable.context3dCache;

			context3dCache.addChildBufferOwner(this);

			//设置渲染参数
			context3dCache.shaderParams = shaderParams;

			if (renderable.animator)
				updateAnimationState(renderable, camera);

			//绘制图形
			context3dCache.render(stage3DProxy.context3D, renderIndex);

			context3dCache.removeChildBufferOwner(this);
		}

		/**
		 * 更新常量数据
		 * @param renderable			渲染对象
		 * @param camera				摄像机
		 */
		protected function updateConstantData(renderable:IRenderable, camera:Camera3D):void
		{

		}

		/**
		 * 标记渲染程序失效
		 */
		arcane function invalidateShaderProgram():void
		{
			markBufferDirty(_.program);
		}

		/**
		 * 更新深度测试缓冲
		 * @param depthTestBuffer			深度测试缓冲
		 */
		protected function updateDepthTestBuffer(depthTestBuffer:DepthTestBuffer):void
		{
			depthTestBuffer.update(_writeDepth && !enableBlending, _depthCompareMode);
		}

		/**
		 * 更新混合因子缓冲
		 * @param blendFactorsBuffer		混合因子缓冲
		 */
		protected function updateBlendFactorsBuffer(blendFactorsBuffer:BlendFactorsBuffer):void
		{
			blendFactorsBuffer.update(_blendFactorSource, _blendFactorDest);
		}

		/**
		 * 更新剔除模式缓冲
		 * @param cullingBuffer		剔除模式缓冲
		 */
		protected function updateCullingBuffer(cullingBuffer:CullingBuffer):void
		{
			cullingBuffer.update(_bothSides ? Context3DTriangleFace.NONE : _defaultCulling);
		}

		/**
		 * 更新（编译）渲染程序
		 */
		arcane function updateProgramBuffer(programBuffer:ProgramBuffer):void
		{
			var result:FagalShaderResult = FagalRE.runShader(V_Main, F_Main);

			//上传程序
			programBuffer.update(result.vertexCode, result.fragmentCode);
		}

		/**
		 * 灯光采集器
		 */
		arcane function get lightPicker():LightPickerBase
		{
			return _lightPicker;
		}

		arcane function set lightPicker(value:LightPickerBase):void
		{
			if (_lightPicker)
				_lightPicker.removeEventListener(Event.CHANGE, onLightsChange);
			_lightPicker = value;
			if (_lightPicker)
				_lightPicker.addEventListener(Event.CHANGE, onLightsChange);
			updateLights();
		}

		/**
		 * 灯光发生变化
		 */
		private function onLightsChange(event:Event):void
		{
			updateLights();
		}

		/**
		 * 更新灯光渲染
		 */
		protected function updateLights():void
		{
			if (_lightPicker)
			{
				_numPointLights = _lightPicker.numPointLights;
				_numDirectionalLights = _lightPicker.numDirectionalLights;
			}
			invalidateShaderProgram();
		}

		/**
		 * 设置混合模式
		 * @param value		混合模式
		 */
		public function setBlendMode(value:String):void
		{
			switch (value)
			{
				case BlendMode.NORMAL:
					_blendFactorSource = Context3DBlendFactor.ONE;
					_blendFactorDest = Context3DBlendFactor.ZERO;
					enableBlending = false;
					break;
				case BlendMode.LAYER:
					_blendFactorSource = Context3DBlendFactor.SOURCE_ALPHA;
					_blendFactorDest = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
					enableBlending = true;
					break;
				case BlendMode.MULTIPLY:
					_blendFactorSource = Context3DBlendFactor.ZERO;
					_blendFactorDest = Context3DBlendFactor.SOURCE_COLOR;
					enableBlending = true;
					break;
				case BlendMode.ADD:
					_blendFactorSource = Context3DBlendFactor.SOURCE_ALPHA;
					_blendFactorDest = Context3DBlendFactor.ONE;
					enableBlending = true;
					break;
				case BlendMode.ALPHA:
					_blendFactorSource = Context3DBlendFactor.ZERO;
					_blendFactorDest = Context3DBlendFactor.SOURCE_ALPHA;
					enableBlending = true;
					break;
				case BlendMode.SCREEN:
					_blendFactorSource = Context3DBlendFactor.ONE;
					_blendFactorDest = Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
					enableBlending = true;
					break;
				default:
					throw new ArgumentError("Unsupported blend mode!");
			}
		}

		/**
		 * 是否写入到深度缓存
		 */
		public function get writeDepth():Boolean
		{
			return _writeDepth;
		}

		public function set writeDepth(value:Boolean):void
		{
			_writeDepth = value;
			markBufferDirty(_.depthTest);
		}

		/**
		 * 深度比较模式
		 */
		public function get depthCompareMode():String
		{
			return _depthCompareMode;
		}

		public function set depthCompareMode(value:String):void
		{
			_depthCompareMode = value;
			markBufferDirty(_.depthTest);
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
			markBufferDirty(_.culling);
		}

		/**
		 * 渲染中是否使用了灯光
		 */
		protected function usesLights():Boolean
		{
			return (_numPointLights > 0 || _numDirectionalLights > 0);
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
			invalidateShaderProgram();
		}

		/**
		 * Cleans up any resources used by the current object.
		 * @param deep Indicates whether other resources should be cleaned up, that could potentially be shared across different instances.
		 */
		public function dispose():void
		{
			if (_lightPicker)
				_lightPicker.removeEventListener(Event.CHANGE, onLightsChange);
		}
	}
}

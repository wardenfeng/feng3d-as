package me.feng3d.fagal.params
{
	import flash.utils.Dictionary;

	import me.feng.component.ComponentContainer;
	import me.feng3d.animators.AnimationType;
	import me.feng3d.textures.TextureProxyBase;
	import me.feng3d.utils.TextureUtils;

	/**
	 * 渲染参数
	 * @author warden_feng 2014-11-4
	 */
	public class ShaderParams extends ComponentContainer
	{
		//-----------------------------------------
		//		通用渲染参数
		//-----------------------------------------
		/** 是否使用贴图分层细化 */
		public var useMipmapping:Boolean;
		/** 是否使用平滑纹理 */
		public var useSmoothTextures:Boolean;
		/** 是否重复纹理 */
		public var repeatTextures:Boolean;

		/** 是否有漫反射贴图 */
		public var hasDiffuseTexture:int;

		/** 是否使用漫反射函数 */
		public var usingDiffuseMethod:int;

		public var useAmbientTexture:int;

		public var alphaThreshold:Number = 0;

		/** 是否需要uv坐标 */
		public var needsUV:int;

		/** 取样标记字典 */
		private var sampleFlagsDic:Dictionary;

		//-----------------------------------------
		//		动画渲染参数
		//-----------------------------------------
		/** 骨骼动画中的骨骼数量 */
		public var numJoints:int;

		/** 每个顶点关联关节的数量 */
		public var jointsPerVertex:int;

		/** 动画Fagal函数类型 */
		public var animationType:AnimationType;

		/** 是否使用uv动画 */
		public var useUVAnimation:int;

		/** 是否使用SpritSheet动画 */
		public var useSpriteSheetAnimation:int;

		//-----------------------------------------
		//		灯光渲染参数
		//-----------------------------------------
		/** 点光源数量 */
		public var numPointLights:uint;
		private var _numDirectionalLights:uint;
		/** 是否使用灯光衰减 */
		public var useLightFallOff:Boolean = true;

		/** 是否需要视线 */
		public var needsViewDir:int;

		/** 方向光源数量 */
		public function get numDirectionalLights():uint
		{
			return _numDirectionalLights;
		}

		/**
		 * @private
		 */
		public function set numDirectionalLights(value:uint):void
		{
			_numDirectionalLights = value;
		}

		/** 漫反射函数 */
		public var diffuseMethod:Function;
		/** 是否使用镜面反射函数 */
		public var usingSpecularMethod:int;

		/** 是否需要法线 */
		public var needsNormals:int;
		/** 是否有法线贴图 */
		public var hasNormalTexture:Boolean;
		/** 是否有光泽贴图 */
		public var hasSpecularTexture:int;

		//------------- 渲染过程参数 ---------------
		/** 是否为第一个渲染的镜面反射灯光 */
		public var isFirstSpecLight:Boolean;

		/** 是否为第一个渲染的漫反射灯光 */
		public var isFirstDiffLight:Boolean;

		//-----------------------------------------
		//		粒子渲染参数
		//-----------------------------------------
		/** 是否持续 */
		public var usesDuration:Boolean;
		/** 是否延时 */
		public var usesDelay:Boolean;
		/** 是否循环 */
		public var usesLooping:Boolean;

		/** 时间静态 */
		public var ParticleTimeLocalStatic:Boolean;
		public var ParticleVelocityGlobal:Boolean;
		public var ParticleVelocityLocalStatic:Boolean;
		public var ParticleBillboardGlobal:Boolean;
		public var ParticleScaleGlobal:Boolean;

		public var ParticleColorGlobal:Boolean;

		/** 是否改变坐标计数 */
		public var changePosition:int;

		/** 是否改变颜色信息 */
		public var changeColor:int;

		//-----------------------------------------
		//		阴影渲染参数
		//-----------------------------------------

		/**
		 * 是否使用阴影映射函数
		 */
		public var usingShadowMapMethod:int;

		/**
		 * 是否使用点光源
		 */
		public var usePoint:int;

		/**
		 * 是否需要投影顶点坐标数据
		 */
		public var needsProjection:int;

		/**
		 * 是否渲染雾
		 */
		public var useFog:int;

		/**
		 * 使用近阴影渲染
		 */
		public var useNearShadowMap:int;

		/**
		 * 是否需要阴影寄存器
		 */
		public var needsShadowRegister:int;

		//-----------------------------------------
		//		地形渲染参数
		//-----------------------------------------
		/** 土壤纹理个数 */
		public var splatNum:int;

		//-----------------------------------------
		//		魔兽争霸地形渲染参数
		//-----------------------------------------
		/** 土壤纹理个数 */
		public var splatNum_war3Terrain:int;

		//-----------------------------------------
		//		
		//-----------------------------------------
		/**  */
		public var useEnvMapMethod:int;

		/**  */
		public var useEnvMapMask:int;

		/**
		 * 是否为入射光
		 */
		public var incidentLight:Boolean;

		public var specularModelType:String;

		public var diffuseModulateMethod:Function;
		public var modulateMethod:Function;

		public var alphaPremultiplied:Boolean;

		/**
		 * 创建一个渲染参数
		 */
		public function ShaderParams()
		{
		}

		/**
		 * 初始化渲染参数
		 */
		public function initParams():void
		{
			init();

			for each (var shaderParam:Object in components)
			{
				if (shaderParam.hasOwnProperty("init"))
				{
					shaderParam["init"]();
				}
			}
		}

		/**
		 * 渲染前初始化
		 */
		public function preRunParams():void
		{
			preRun();

			for each (var shaderParam:Object in components)
			{
				if (shaderParam.hasOwnProperty("preRun"))
				{
					shaderParam["preRun"]();
				}
			}
		}

		/**
		 * 初始化
		 */
		public function init():void
		{
			useMipmapping = false;
			useSmoothTextures = false;
			repeatTextures = false;

			hasDiffuseTexture = 0;
			needsUV = 0;

			sampleFlagsDic = new Dictionary();

			//
			numJoints = 0;
			animationType = AnimationType.NONE;
			useUVAnimation = 0;

			//
			numPointLights = 0;
			numDirectionalLights = 0;
			needsNormals = 0;
			needsViewDir = 0;

			//
			changePosition = 0;
			changeColor = 0;

			//
			splatNum = 0;
			splatNum_war3Terrain = 0;

			usingShadowMapMethod = 0;
			usePoint = 0;
			needsProjection = 0;
			useFog = 0;
			useNearShadowMap = 0;
			needsShadowRegister = 0;
		}

		/**
		 * 运行渲染程序前
		 */
		public function preRun():void
		{
			isFirstSpecLight = true;
			isFirstDiffLight = true;
		}

		/**
		 * 添加纹理取样参数
		 * @param dataTypeId		纹理数据缓冲类型编号
		 * @param texture			纹理代理
		 * @param forceWrap			强制重复纹理参数
		 */
		public function addSampleFlags(dataTypeId:String, texture:TextureProxyBase, forceWrap:String = null):void
		{
			sampleFlagsDic[dataTypeId] = null;
			if (texture)
			{
				var flags:Array = TextureUtils.getFlags(useMipmapping, useSmoothTextures, repeatTextures, texture, forceWrap);
				sampleFlagsDic[dataTypeId] = flags;
			}
		}

		/**
		 * 设置取样标记
		 * @param dataTypeId		纹理数据缓冲类型编号
		 * @param flags				纹理取样标记
		 */
		public function setSampleFlags(dataTypeId:String, flags:Array):void
		{
			sampleFlagsDic[dataTypeId] = flags;
		}

		/**
		 * 获取取样标记
		 * @param dataTypeId		纹理数据缓冲类型编号
		 * @return					纹理取样标记
		 */
		public function getFlags(dataTypeId:String):Array
		{
			return sampleFlagsDic[dataTypeId];
		}

		/** 灯光数量 */
		public function get numLights():int
		{
			return numPointLights + numDirectionalLights;
		}

		/** 是否需要世界坐标 */
		public function get needWorldPosition():Boolean
		{
			return needsViewDir || numPointLights > 0;
		}

		/** 片段程序是否需要世界坐标 */
		public function get usesGlobalPosFragment():Boolean
		{
			return numPointLights > 0;
		}


	}
}

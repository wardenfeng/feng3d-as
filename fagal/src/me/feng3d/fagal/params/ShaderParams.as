package me.feng3d.fagal.params
{
	import flash.utils.Dictionary;

	import me.feng.component.ComponentContainer;
	import me.feng3d.textures.TextureProxyBase;
	import me.feng3d.utils.TextureUtils;

	/**
	 * 渲染参数
	 * <p>? 是否需要限定组件为ShaderParamsComponent</p>
	 * @author feng 2014-11-4
	 */
	public class ShaderParams extends ComponentContainer
	{
		/**
		 * 组件名称
		 */
		public static const NAME:String = "ShaderParams";

		/** 取样标记字典 */
		private var sampleFlagsDic:Dictionary;

		/** 是否使用贴图分层细化 */
		public var useMipmapping:Boolean;
		/** 是否使用平滑纹理 */
		public var useSmoothTextures:Boolean;
		/** 是否重复纹理 */
		public var repeatTextures:Boolean;

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
			super(NAME);
			addComponent(new CommonShaderParams());
			addComponent(new AnimationShaderParams());
			addComponent(new LightShaderParams());
			addComponent(new ParticleShaderParams());
			addComponent(new ShadowShaderParams());
			addComponent(new FogShaderParams());
			addComponent(new TerrainShaderParams());
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
			sampleFlagsDic = new Dictionary();

			splatNum_war3Terrain = 0;
		}

		/**
		 * 运行渲染程序前
		 */
		public function preRun():void
		{
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

	}
}

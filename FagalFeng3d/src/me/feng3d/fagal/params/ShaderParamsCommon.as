package me.feng3d.fagal.params
{
	import flash.utils.Dictionary;

	import me.feng.component.Component;
	import me.feng3d.fagal.params.data.SampleFlagsData;
	import me.feng3d.textures.TextureProxyBase;
	import me.feng3d.utils.TextureUtils;

	/**
	 * 通用渲染参数
	 * @author warden_feng 2015-4-28
	 */
	public class ShaderParamsCommon extends Component
	{
		/**
		 * 渲染参数名称
		 */
		public static const NAME:String = "commonShaderParams";

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
		public var hasDiffuseTexture:Boolean;

		/** 是否使用漫反射函数 */
		public var usingDiffuseMethod:int;

		/** 是否需要uv坐标 */
		public var needsUV:int;

		/** 取样标记字典 */
		private var sampleFlagsDic:Dictionary;

		/**
		 * 创建一个通用渲染参数
		 */
		public function ShaderParamsCommon()
		{
			componentName = NAME;
		}

		/**
		 * 初始化
		 */
		public function init():void
		{
			useMipmapping = false;
			useSmoothTextures = false;
			repeatTextures = false;

			hasDiffuseTexture = false;
			needsUV = 0;

			sampleFlagsDic = new Dictionary();

			addEventListener(ShaderParamsEvent.GET_SAMPLE_FLAGS, onGetSampleFlags);
		}

		/**
		 * 处理获取取样标记
		 * @param event
		 */
		private function onGetSampleFlags(event:ShaderParamsEvent):void
		{
			var sampleFlagsData:SampleFlagsData = event.data;
			sampleFlagsData.flags = getFlags(sampleFlagsData.textureRegId);
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
		private function getFlags(dataTypeId:String):Array
		{
			return sampleFlagsDic[dataTypeId];
		}
	}
}

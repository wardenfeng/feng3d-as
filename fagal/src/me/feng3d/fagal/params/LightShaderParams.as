package me.feng3d.fagal.params
{
	import me.feng.component.Component;


	/**
	 * 灯光渲染参数
	 * @author warden_feng 2015-12-1
	 */
	public class LightShaderParams extends Component
	{
		/**
		 * 组件名称
		 */
		public static const NAME:String = "LightShaderParams";

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

		/**
		 * 灯光渲染参数
		 */
		public function LightShaderParams()
		{
			super(NAME);
		}

		/**
		 * 初始化
		 */
		public function init():void
		{
			//
			numPointLights = 0;
			numDirectionalLights = 0;
			needsNormals = 0;
			needsViewDir = 0;
		}

		/**
		 * 运行渲染程序前
		 */
		public function preRun():void
		{
			isFirstSpecLight = true;
			isFirstDiffLight = true;
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

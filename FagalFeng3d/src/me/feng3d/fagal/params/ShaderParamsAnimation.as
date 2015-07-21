package me.feng3d.fagal.params
{
	import me.feng.component.Component;
	import me.feng3d.animators.AnimationType;
	import me.feng3d.fagal.register.ShaderRegisterAnimation;

	/**
	 * 动画渲染参数
	 * @author warden_feng 2015-4-29
	 */
	public class ShaderParamsAnimation extends Component
	{
		/**
		 * 渲染参数名称
		 */
		public static const NAME:String = "animationShaderParams";

		//-----------------------------------------
		//		动画渲染参数
		//-----------------------------------------
		/** 骨骼动画中的骨骼数量 */
		public var numJoints:int;

		/** 每个顶点关联关节的数量 */
		public var jointsPerVertex:int;

		/** 动画Fagal函数类型 */
		public var animationType:AnimationType;

		//-----------------------------------------
		//		private
		//-----------------------------------------
		private var _registerAnimation:ShaderRegisterAnimation;

		/**
		 * 动画渲染相关寄存器
		 */
		public function get registerAnimation():ShaderRegisterAnimation
		{
			return _registerAnimation ||= new ShaderRegisterAnimation();
		}

		/**
		 * 创建一个动画渲染参数
		 */
		public function ShaderParamsAnimation()
		{
			componentName = NAME;
		}

		/**
		 * 初始化
		 */
		public function init():void
		{
			numJoints = 0;

			animationType = AnimationType.NONE;

			registerAnimation.init();
		}
	}
}

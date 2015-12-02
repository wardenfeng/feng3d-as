package me.feng3d.fagal.params
{
	import me.feng.component.Component;
	import me.feng3d.animators.AnimationType;


	/**
	 * 动画渲染参数
	 * @author warden_feng 2015-12-1
	 */
	public class AnimationShaderParams extends Component
	{
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

		/**
		 * 动画渲染参数
		 */
		public function AnimationShaderParams()
		{
			super();
		}

		public function init():void
		{
			//
			numJoints = 0;
			animationType = AnimationType.NONE;
			useUVAnimation = 0;
		}
	}
}

package me.feng3d.fagal.params
{
	import me.feng.component.Component;


	/**
	 * 粒子渲染参数
	 * @author warden_feng 2015-12-1
	 */
	public class ParticleShaderParams extends Component
	{
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

		/**
		 * 粒子渲染参数
		 */
		public function ParticleShaderParams()
		{
			super();
		}

		/**
		 * 初始化
		 */
		public function init():void
		{
			//
			changePosition = 0;
			changeColor = 0;
		}
	}
}

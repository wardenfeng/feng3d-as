package me.feng3d.fagal.params
{
	import me.feng.component.Component;

	/**
	 * 粒子渲染参数
	 * @author warden_feng 2015-1-14
	 */
	public class ShaderParamsParticle extends Component
	{
		/**
		 * 渲染参数名称
		 */
		public static const NAME:String = "particleShaderParams";

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
		 * 创建一个粒子渲染参数
		 */
		public function ShaderParamsParticle()
		{
			componentName = NAME;

			changePosition = 0;
			changeColor = 0;
		}

		/**
		 * 设置渲染数据
		 * @param data
		 */
		public function setData(data:ShaderParamsParticle):void
		{
			usesDuration = data.usesDuration;
			usesDelay = data.usesDelay;
			usesLooping = data.usesLooping;
			ParticleTimeLocalStatic = data.ParticleTimeLocalStatic;
			ParticleVelocityGlobal = data.ParticleVelocityGlobal;
			ParticleVelocityLocalStatic = data.ParticleVelocityLocalStatic;
			ParticleBillboardGlobal = data.ParticleBillboardGlobal;
			ParticleScaleGlobal = data.ParticleScaleGlobal;
			ParticleColorGlobal = data.ParticleColorGlobal;
			changePosition = data.changePosition;
			changeColor = data.changeColor;
		}
	}
}

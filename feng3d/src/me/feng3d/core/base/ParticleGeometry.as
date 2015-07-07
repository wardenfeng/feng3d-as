package me.feng3d.core.base
{
	import me.feng3d.core.base.data.ParticleData;

	/**
	 * 粒子几何体
	 */
	public class ParticleGeometry extends Geometry
	{
		/**
		 * 粒子数据
		 */
		public var particles:Vector.<ParticleData>;

		/**
		 * 粒子数量
		 */
		public var numParticles:uint;

		public function ParticleGeometry()
		{
			super();
		}

		override public function clone():Geometry
		{
			var particleGeometry:ParticleGeometry = super.clone() as ParticleGeometry;
			particleGeometry.particles = particles;
			particleGeometry.numParticles = numParticles;
			return particleGeometry;
		}
	}

}

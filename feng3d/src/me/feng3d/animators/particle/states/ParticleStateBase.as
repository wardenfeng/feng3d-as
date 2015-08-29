package me.feng3d.animators.particle.states
{
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	import me.feng3d.arcane;
	import me.feng3d.animators.base.states.AnimationStateBase;
	import me.feng3d.animators.particle.ParticleAnimator;
	import me.feng3d.animators.particle.node.ParticleNodeBase;

	use namespace arcane;

	/**
	 * ...
	 */
	public class ParticleStateBase extends AnimationStateBase
	{
		private var _particleNode:ParticleNodeBase;

		protected var _dynamicProperties:Vector.<Vector3D> = new Vector.<Vector3D>();
		protected var _dynamicPropertiesDirty:Dictionary = new Dictionary(true);

		protected var _needUpdateTime:Boolean;

		public function ParticleStateBase(animator:ParticleAnimator, particleNode:ParticleNodeBase, needUpdateTime:Boolean = false)
		{
			super(animator, particleNode);

			_particleNode = particleNode;
			_needUpdateTime = needUpdateTime;
		}

		public function get needUpdateTime():Boolean
		{
			return _needUpdateTime;
		}
	}

}

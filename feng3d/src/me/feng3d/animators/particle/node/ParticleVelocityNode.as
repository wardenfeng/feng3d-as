package me.feng3d.animators.particle.node
{
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.animators.particle.data.ParticleProperties;
	import me.feng3d.animators.particle.data.ParticlePropertiesMode;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;

	import me.feng3d.fagal.params.ShaderParams;

	use namespace arcane;

	/**
	 * 粒子速度节点
	 * @author warden_feng 2014-11-13
	 */
	public class ParticleVelocityNode extends ParticleNodeBase
	{
		/** 粒子速度 */
		arcane const _velocity:Vector.<Number> = Vector.<Number>([1, 1, 1, 0]);

		/**
		 * 粒子的速度属性
		 */
		public static const VELOCITY_VECTOR3D:String = "VelocityVector3D";

		override public function get propertieName():String
		{
			return VELOCITY_VECTOR3D;
		}

		override public function get vaId():String
		{
			return _.particleVelocity_va_3;
		}

		override public function get vaLen():uint
		{
			return 3;
		}

		/**
		 * 创建一个粒子速度节点
		 * @param mode		模式
		 * @param velocity	粒子速度
		 */
		public function ParticleVelocityNode(mode:uint, velocity:Vector3D = null)
		{
			super("ParticleVelocity", mode, 3);

			if (velocity)
			{
				_velocity[0] = velocity.x;
				_velocity[1] = velocity.y;
				_velocity[2] = velocity.z;
			}
			else
			{
				_velocity[0] = 0;
				_velocity[1] = 0;
				_velocity[2] = 0;
			}
		}

		override protected function initBuffers():void
		{
			super.initBuffers();

			if (mode == ParticlePropertiesMode.GLOBAL)
				mapContext3DBuffer(_.particleVelocity_vc_vector, updateVelocityConstBuffer);
		}

		private function updateVelocityConstBuffer(velocityConstBuffer:VCVectorBuffer):void
		{
			velocityConstBuffer.update(_velocity);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function generatePropertyOfOneParticle(param:ParticleProperties):void
		{
			var _tempVelocity:Vector3D = param[VELOCITY_VECTOR3D];
			if (!_tempVelocity)
				throw new Error("there is no " + VELOCITY_VECTOR3D + " in param!");

			_oneData[0] = _tempVelocity.x;
			_oneData[1] = _tempVelocity.y;
			_oneData[2] = _tempVelocity.z;
		}

		/**
		 * @inheritDoc
		 */
		override arcane function processAnimationSetting(shaderParam:ShaderParams):void
		{
			shaderParam.changePosition++;
			shaderParam[name] = true;
		}
	}
}

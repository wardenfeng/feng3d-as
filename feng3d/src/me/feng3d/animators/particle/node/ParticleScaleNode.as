package me.feng3d.animators.particle.node
{
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.animators.particle.data.ParticleProperties;
	import me.feng3d.animators.particle.data.ParticlePropertiesMode;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.fagal.params.ParticleShaderParams;
	import me.feng3d.fagal.params.ShaderParams;

	use namespace arcane;

	/**
	 * 粒子缩放节点
	 * @author feng 2015-1-15
	 */
	public class ParticleScaleNode extends ParticleNodeBase
	{
		private var _minScale:Number;
		private var _maxScale:Number;

		private var _scaleData:Vector.<Number>;

		/**
		 * 缩放属性名
		 */
		public static const SCALE_VECTOR3D:String = "ScaleVector3D";

		/**
		 * 最小缩放
		 */
		public function get minScale():Number
		{
			return _minScale;
		}

		public function set minScale(value:Number):void
		{
			_minScale = value;

			updateScaleData();
		}

		/**
		 * 最大缩放
		 */
		public function get maxScale():Number
		{
			return _maxScale;
		}

		public function set maxScale(value:Number):void
		{
			_maxScale = value;

			updateScaleData();
		}

		/**
		 * 创建一个粒子缩放节点
		 * @param mode				模式
		 * @param usesCycle
		 * @param usesPhase
		 * @param minScale			最小缩放
		 * @param maxScale			最大缩放
		 * @param cycleDuration
		 * @param cyclePhase
		 */
		public function ParticleScaleNode(mode:uint, usesCycle:Boolean, usesPhase:Boolean, minScale:Number = 1, maxScale:Number = 1, cycleDuration:Number = 1, cyclePhase:Number = 0)
		{
			var len:int = 2;
			if (usesCycle)
				len++;
			if (usesPhase)
				len++;
			super("ParticleScale", mode, len, 3);

			_minScale = minScale;
			_maxScale = maxScale;

			updateScaleData();
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();

			if (mode == ParticlePropertiesMode.GLOBAL)
				context3DBufferOwner.mapContext3DBuffer(_.particleScale_vc_vector, updateVelocityConstBuffer);
		}

		private function updateVelocityConstBuffer(velocityConstBuffer:VCVectorBuffer):void
		{
			velocityConstBuffer.update(_scaleData);
		}

		private function updateScaleData():void
		{
			if (mode == ParticlePropertiesMode.GLOBAL)
			{
				_scaleData = Vector.<Number>([_minScale, _maxScale - _minScale, 0, 0]);
			}
		}

		/**
		 * @inheritDoc
		 */
		override arcane function generatePropertyOfOneParticle(param:ParticleProperties):void
		{
			var scale:Vector3D = param[SCALE_VECTOR3D];
			if (!scale)
				throw(new Error("there is no " + SCALE_VECTOR3D + " in param!"));

			_oneData[0] = scale.x;
			_oneData[1] = scale.y - scale.x;
		}

		/**
		 * @inheritDoc
		 */
		override arcane function processAnimationSetting(shaderParams:ShaderParams):void
		{
			var particleShaderParams:ParticleShaderParams = shaderParams.getOrCreateComponentByClass(ParticleShaderParams);

			particleShaderParams.changePosition++;
			particleShaderParams[name] = true;
		}
	}
}



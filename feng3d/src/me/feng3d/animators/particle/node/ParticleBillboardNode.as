package me.feng3d.animators.particle.node
{
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.animators.particle.data.ParticlePropertiesMode;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.fagal.params.ParticleShaderParams;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.mathlib.MathConsts;
	import me.feng3d.mathlib.Matrix3DUtils;

	use namespace arcane;

	/**
	 * 广告牌节点
	 * @author feng 2014-11-13
	 */
	public class ParticleBillboardNode extends ParticleNodeBase
	{
		private const _matrix:Matrix3D = new Matrix3D;

		/** 广告牌轴线 */
		arcane var _billboardAxis:Vector3D;

		/**
		 * 创建一个广告牌节点
		 * @param billboardAxis
		 */
		public function ParticleBillboardNode(billboardAxis:Vector3D = null)
		{
			super("ParticleBillboard", ParticlePropertiesMode.GLOBAL, 0, 4);

			this.billboardAxis = billboardAxis;
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();

			context3DBufferOwner.mapContext3DBuffer(_.particleBillboard_vc_matrix, updateBillboardMatrixBuffer);
		}

		private function updateBillboardMatrixBuffer(billboardMatrixBuffer:VCMatrixBuffer):void
		{
			billboardMatrixBuffer.update(_matrix, true);
		}

		/**
		 * @inheritDoc
		 */
		override public function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{
			var comps:Vector.<Vector3D>;
			if (_billboardAxis)
			{
				var pos:Vector3D = renderable.sourceEntity.sceneTransform.position;
				var look:Vector3D = camera.sceneTransform.position.subtract(pos);
				var right:Vector3D = look.crossProduct(_billboardAxis);
				right.normalize();
				look = _billboardAxis.crossProduct(right);
				look.normalize();

				//create a quick inverse projection matrix
				_matrix.copyFrom(renderable.sourceEntity.sceneTransform);
				comps = Matrix3DUtils.decompose(_matrix, Orientation3D.AXIS_ANGLE);
				_matrix.copyColumnFrom(0, right);
				_matrix.copyColumnFrom(1, _billboardAxis);
				_matrix.copyColumnFrom(2, look);
				_matrix.copyColumnFrom(3, pos);
				_matrix.appendRotation(-comps[1].w * MathConsts.RADIANS_TO_DEGREES, comps[1]);
			}
			else
			{
				//create a quick inverse projection matrix
				_matrix.copyFrom(renderable.sourceEntity.sceneTransform);
				_matrix.append(camera.inverseSceneTransform);

				//decompose using axis angle rotations
				comps = Matrix3DUtils.decompose(_matrix, Orientation3D.AXIS_ANGLE);

				//recreate the matrix with just the rotation data
				_matrix.identity();
				_matrix.appendRotation(-comps[1].w * MathConsts.RADIANS_TO_DEGREES, comps[1]);
			}

			context3DBufferOwner.markBufferDirty(_.particleBillboard_vc_matrix);
		}

		/**
		 * 广告牌轴线
		 */
		public function get billboardAxis():Vector3D
		{
			return _billboardAxis;
		}

		public function set billboardAxis(value:Vector3D):void
		{
			_billboardAxis = value ? value.clone() : null;
			if (_billboardAxis)
				_billboardAxis.normalize();
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

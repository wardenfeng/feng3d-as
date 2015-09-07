package me.feng3d.animators.uv
{
	import flash.geom.Matrix;

	import me.feng3d.arcane;
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.AnimatorBase;
	import me.feng3d.animators.base.transitions.IAnimationTransition;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.core.math.MathConsts;
	import me.feng3d.materials.TextureMaterial;

	use namespace arcane;

	/**
	 * Provides an interface for assigning uv-based animation data sets to mesh-based entity objects
	 * and controlling the various available states of animation through an interative playhead that can be
	 * automatically updated or manually triggered.
	 */
	public class UVAnimator extends AnimatorBase implements IAnimator
	{
		private const _matrix2d:Vector.<Number> = Vector.<Number>([1, 0, 0, 0, 1, 0, 0, 0]);
		private const _translate:Vector.<Number> = Vector.<Number>([0, 0, 0.5, 0.5]);

		private var _uvAnimationSet:UVAnimationSet;
		private var _deltaFrame:UVAnimationFrame = new UVAnimationFrame();
		private var _activeUVState:IUVAnimationState;

		private var _uvTransform:Matrix;

		private var _autoRotation:Boolean;
		private var _rotationIncrease:Number = 1;
		private var _autoTranslate:Boolean;
		private var _translateIncrease:Vector.<Number>;

		/**
		 * Creates a new <code>UVAnimator</code> object.
		 *
		 * @param uvAnimationSet The animation data set containing the uv animations used by the animator.
		 */
		public function UVAnimator(uvAnimationSet:UVAnimationSet)
		{
			super(uvAnimationSet);

			_uvTransform = new Matrix();
			_uvAnimationSet = uvAnimationSet;
		}

		/**
		 * Defines if a rotation is performed automatically each update. The rotationIncrease value is added each iteration.
		 */
		public function set autoRotation(b:Boolean):void
		{
			_autoRotation = b;
		}

		public function get autoRotation():Boolean
		{
			return _autoRotation;
		}

		/**
		 * if autoRotation = true, the rotation is increased by the rotationIncrease value. Default is 1;
		 */
		public function set rotationIncrease(value:Number):void
		{
			_rotationIncrease = value;
		}

		public function get rotationIncrease():Number
		{
			return _rotationIncrease;
		}

		/**
		 * Defines if the animation is translated automatically each update. Ideal to scroll maps. Use setTranslateIncrease to define the offsets.
		 */
		public function set autoTranslate(b:Boolean):void
		{
			_autoTranslate = b;
			if (b && !_translateIncrease)
				_translateIncrease = Vector.<Number>([0, 0]);
		}

		public function get autoTranslate():Boolean
		{
			return _autoTranslate;
		}

		/**
		 * if autoTranslate = true, animation is translated automatically each update with the u and v values.
		 * Note if value are integers, no visible update will be performed. Values are expected to be in 0-1 range.
		 */
		public function setTranslateIncrease(u:Number, v:Number):void
		{
			if (!_translateIncrease)
				_translateIncrease = Vector.<Number>([0, 0]);
			_translateIncrease[0] = u;
			_translateIncrease[1] = v;
		}

		public function get translateIncrease():Vector.<Number>
		{
			return _translateIncrease;
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.uvAnimatorTranslate_vc_vector, updateTranslateBuffer);
			mapContext3DBuffer(_.uvAnimatorMatrix2d_vc_vector, updateMatrix2dBuffer);
		}

		private function updateTranslateBuffer(buffer:VCVectorBuffer):void
		{
			buffer.update(_translate);
		}

		private function updateMatrix2dBuffer(buffer:VCVectorBuffer):void
		{
			buffer.update(_matrix2d);
		}

		/**
		 * @inheritDoc
		 */
		public function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{
			var material:TextureMaterial = renderable.material as TextureMaterial;
			var subMesh:SubMesh = renderable as SubMesh;

			if (!material || !subMesh)
				return;

			if (autoTranslate)
			{
				_deltaFrame.offsetU += _translateIncrease[0];
				_deltaFrame.offsetV += _translateIncrease[1];
			}

			_translate[0] = _deltaFrame.offsetU;
			_translate[1] = _deltaFrame.offsetV;

			_uvTransform.identity();

			if (_autoRotation)
				_deltaFrame.rotation += _rotationIncrease;

			if (_deltaFrame.rotation != 0)
				_uvTransform.rotate(_deltaFrame.rotation * MathConsts.DEGREES_TO_RADIANS);
			if (_deltaFrame.scaleU != 1 || _deltaFrame.scaleV != 1)
				_uvTransform.scale(_deltaFrame.scaleU, _deltaFrame.scaleV);

			_matrix2d[0] = _uvTransform.a;
			_matrix2d[1] = _uvTransform.b;
			_matrix2d[3] = _uvTransform.tx;
			_matrix2d[4] = _uvTransform.c;
			_matrix2d[5] = _uvTransform.d;
			_matrix2d[7] = _uvTransform.ty;
		}

		/**
		 * @inheritDoc
		 */
		public function play(name:String, transition:IAnimationTransition = null, offset:Number = NaN):void
		{
			transition = transition;
			offset = offset;
			if (_activeAnimationName == name)
				return;

			_activeAnimationName = name;

			if (!_animationSet.hasAnimation(name))
				throw new Error("Animation root node " + name + " not found!");

			_activeNode = _animationSet.getAnimation(name);
			_activeState = getAnimationState(_activeNode);
			_activeUVState = _activeState as IUVAnimationState;

			start();
		}

		/**
		 * Applies the calculated time delta to the active animation state node.
		 */
		override protected function updateDeltaTime(dt:Number):void
		{
			_absoluteTime += dt;
			_activeUVState.update(_absoluteTime);

			var currentUVFrame:UVAnimationFrame = _activeUVState.currentUVFrame;
			var nextUVFrame:UVAnimationFrame = _activeUVState.nextUVFrame;
			var blendWeight:Number = _activeUVState.blendWeight;

			if (currentUVFrame && nextUVFrame)
			{
				_deltaFrame.offsetU = currentUVFrame.offsetU + blendWeight * (nextUVFrame.offsetU - currentUVFrame.offsetU);
				_deltaFrame.offsetV = currentUVFrame.offsetV + blendWeight * (nextUVFrame.offsetV - currentUVFrame.offsetV);
				_deltaFrame.scaleU = currentUVFrame.scaleU + blendWeight * (nextUVFrame.scaleU - currentUVFrame.scaleU);
				_deltaFrame.scaleV = currentUVFrame.scaleV + blendWeight * (nextUVFrame.scaleV - currentUVFrame.scaleV);
				_deltaFrame.rotation = currentUVFrame.rotation + blendWeight * (nextUVFrame.rotation - currentUVFrame.rotation);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function clone():IAnimator
		{
			return new UVAnimator(_uvAnimationSet);
		}

	}
}

package me.feng3d.animators.uv
{
	import flash.geom.Matrix;

	import me.feng3d.arcane;
	import me.feng3d.animators.base.AnimatorBase;
	import me.feng3d.animators.base.AnimatorBase;
	import me.feng3d.animators.base.transitions.IAnimationTransition;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.materials.TextureMaterial;
	import me.feng3d.mathlib.MathConsts;

	use namespace arcane;

	/**
	 * UV动画
	 * @author feng 2014-5-27
	 */
	public class UVAnimator extends AnimatorBase
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
		 * 创建<code>UVAnimator</code>实例
		 * @param uvAnimationSet			UV动画集合
		 */
		public function UVAnimator(uvAnimationSet:UVAnimationSet)
		{
			super(uvAnimationSet);

			_uvTransform = new Matrix();
			_uvAnimationSet = uvAnimationSet;
		}

		public function set autoRotation(b:Boolean):void
		{
			_autoRotation = b;
		}

		/**
		 * 是否自动旋转
		 */
		public function get autoRotation():Boolean
		{
			return _autoRotation;
		}

		public function set rotationIncrease(value:Number):void
		{
			_rotationIncrease = value;
		}

		/**
		 * 旋转增量（当autoRotation = true生效）
		 */
		public function get rotationIncrease():Number
		{
			return _rotationIncrease;
		}

		public function set autoTranslate(b:Boolean):void
		{
			_autoTranslate = b;
			if (b && !_translateIncrease)
				_translateIncrease = Vector.<Number>([0, 0]);
		}

		/**
		 * 是否自动转换
		 */
		public function get autoTranslate():Boolean
		{
			return _autoTranslate;
		}

		/**
		 * 设置转换值
		 * @param u
		 * @param v
		 */
		public function setTranslateIncrease(u:Number, v:Number):void
		{
			if (!_translateIncrease)
				_translateIncrease = Vector.<Number>([0, 0]);
			_translateIncrease[0] = u;
			_translateIncrease[1] = v;
		}

		/**
		 * 转换值
		 */
		public function get translateIncrease():Vector.<Number>
		{
			return _translateIncrease;
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			context3DBufferOwner.mapContext3DBuffer(_.uvAnimatorTranslate_vc_vector, updateTranslateBuffer);
			context3DBufferOwner.mapContext3DBuffer(_.uvAnimatorMatrix2d_vc_vector, updateMatrix2dBuffer);
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
		override public function setRenderState(renderable:IRenderable, camera:Camera3D):void
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
		 * @inheritDoc
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
		public function clone():AnimatorBase
		{
			return new UVAnimator(_uvAnimationSet);
		}

	}
}

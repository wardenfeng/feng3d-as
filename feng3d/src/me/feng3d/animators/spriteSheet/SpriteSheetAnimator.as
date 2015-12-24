package me.feng3d.animators.spriteSheet
{
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	import me.feng3d.arcane;
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.AnimatorBase;
	import me.feng3d.animators.base.transitions.IAnimationTransition;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.materials.MaterialBase;
	import me.feng3d.materials.SpriteSheetMaterial;
	import me.feng3d.materials.TextureMaterial;

	use namespace arcane;

	/**
	 * sprite动画
	 * @author feng 2014-5-27
	 */
	public class SpriteSheetAnimator extends AnimatorBase
	{
		private const _vectorFrame:Vector.<Number> = new Vector.<Number>(4, true);

		private var _activeSpriteSheetState:ISpriteSheetAnimationState;
		private var _spriteSheetAnimationSet:SpriteSheetAnimationSet;
		private var _frame:SpriteSheetAnimationFrame = new SpriteSheetAnimationFrame();
		private var _fps:uint = 10;
		private var _ms:uint = 100;
		private var _lastTime:uint;
		private var _reverse:Boolean;
		private var _backAndForth:Boolean;
		private var _specsDirty:Boolean;
		private var _mapDirty:Boolean;

		/**
		 * 创建sprite动画实例
		 * @param spriteSheetAnimationSet			sprite动画集合
		 */
		public function SpriteSheetAnimator(spriteSheetAnimationSet:SpriteSheetAnimationSet)
		{
			super(spriteSheetAnimationSet);
			_spriteSheetAnimationSet = spriteSheetAnimationSet;
		}

		public function set fps(val:uint):void
		{
			_ms = 1000 / val;
			_fps = val;
		}

		/**
		 * 帧率
		 */
		public function get fps():uint
		{
			return _fps;
		}

		public function set reverse(b:Boolean):void
		{
			_reverse = b;
			_specsDirty = true;
		}

		/**
		 * 是否反向
		 */
		public function get reverse():Boolean
		{
			return _reverse;
		}

		public function set backAndForth(b:Boolean):void
		{
			_backAndForth = b;
			_specsDirty = true;
		}

		/**
		 * 改变播放方向
		 */
		public function get backAndForth():Boolean
		{
			return _backAndForth;
		}

		/**
		 * 跳到某帧播放（起始帧为1）
		 * @param frameNumber			帧编号
		 */
		public function gotoAndPlay(frameNumber:uint):void
		{
			gotoFrame(frameNumber, true);
		}

		/**
		 * 跳到某帧停止（起始帧为1）
		 * @param frameNumber			帧编号
		 */
		public function gotoAndStop(frameNumber:uint):void
		{
			gotoFrame(frameNumber, false);
		}

		/**
		 * 当前帧编号
		 */
		public function get currentFrameNumber():uint
		{
			return SpriteSheetAnimationState(_activeState).currentFrameNumber;
		}

		/**
		 * 总帧数
		 */
		public function get totalFrames():uint
		{
			return SpriteSheetAnimationState(_activeState).totalFrames;
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(_.spriteSheetVectorFrame_vc_vector, updateVectorFrameBuffer);
		}

		private function updateVectorFrameBuffer(vcVectorBuffer:VCVectorBuffer):void
		{
			vcVectorBuffer.update(_vectorFrame);
		}

		/**
		 * @inheritDoc
		 */
		override public function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{
			var material:MaterialBase = renderable.material;
			if (!material || !material is TextureMaterial)
				return;

			var subMesh:SubMesh = renderable as SubMesh;
			if (!subMesh)
				return;

			//because textures are already uploaded, we can't offset the uv's yet
			var swapped:Boolean;

			if (material is SpriteSheetMaterial && _mapDirty)
				swapped = SpriteSheetMaterial(material).swap(_frame.mapID);

			if (!swapped)
			{
				_vectorFrame[0] = _frame.offsetU;
				_vectorFrame[1] = _frame.offsetV;
				_vectorFrame[2] = _frame.scaleU;
				_vectorFrame[3] = _frame.scaleV;
			}
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
			_frame = SpriteSheetAnimationState(_activeState).currentFrameData;
			_activeSpriteSheetState = _activeState as ISpriteSheetAnimationState;

			start();
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateDeltaTime(dt:Number):void
		{
			if (_specsDirty)
			{
				SpriteSheetAnimationState(_activeSpriteSheetState).reverse = _reverse;
				SpriteSheetAnimationState(_activeSpriteSheetState).backAndForth = _backAndForth;
				_specsDirty = false;
			}

			_absoluteTime += dt;
			var now:int = getTimer();

			if ((now - _lastTime) > _ms)
			{
				_mapDirty = true;
				_activeSpriteSheetState.update(_absoluteTime);
				_frame = SpriteSheetAnimationState(_activeSpriteSheetState).currentFrameData;
				_lastTime = now;

			}
			else
				_mapDirty = false;

		}

		/**
		 * 克隆
		 */
		public function clone():IAnimator
		{
			return new SpriteSheetAnimator(_spriteSheetAnimationSet);
		}

		/**
		 * 跳转某帧
		 * @param frameNumber			帧编号
		 * @param doPlay				是否播放
		 */
		private function gotoFrame(frameNumber:uint, doPlay:Boolean):void
		{
			if (!_activeState)
				return;
			SpriteSheetAnimationState(_activeState).currentFrameNumber = (frameNumber == 0) ? frameNumber : frameNumber - 1;
			var currentMapID:uint = _frame.mapID;
			_frame = SpriteSheetAnimationState(_activeSpriteSheetState).currentFrameData;

			if (doPlay)
				start();
			else
			{
				if (currentMapID != _frame.mapID)
				{
					_mapDirty = true;
					setTimeout(stop, _fps);
				}
				else
					stop();

			}
		}

	}
}

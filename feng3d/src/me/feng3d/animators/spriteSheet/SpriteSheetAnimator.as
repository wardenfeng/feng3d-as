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
	import me.feng3d.passes.MaterialPassBase;

	use namespace arcane;

	/**
	 * Provides an interface for assigning uv-based sprite sheet animation data sets to mesh-based entity objects
	 * and controlling the various available states of animation through an interative playhead that can be
	 * automatically updated or manually triggered.
	 */
	public class SpriteSheetAnimator extends AnimatorBase implements IAnimator
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
		 * Creates a new <code>SpriteSheetAnimator</code> object.
		 * @param spriteSheetAnimationSet  The animation data set containing the sprite sheet animation states used by the animator.
		 */
		public function SpriteSheetAnimator(spriteSheetAnimationSet:SpriteSheetAnimationSet)
		{
			super(spriteSheetAnimationSet);
			_spriteSheetAnimationSet = spriteSheetAnimationSet;
		}

		/* Set the playrate of the animation in frames per second (not depending on player fps)*/
		public function set fps(val:uint):void
		{
			_ms = 1000 / val;
			_fps = val;
		}

		public function get fps():uint
		{
			return _fps;
		}

		/* If true, reverse causes the animation to play backwards*/
		public function set reverse(b:Boolean):void
		{
			_reverse = b;
			_specsDirty = true;
		}

		public function get reverse():Boolean
		{
			return _reverse;
		}

		/* If true, backAndForth causes the animation to play backwards and forward alternatively. Starting forward.*/
		public function set backAndForth(b:Boolean):void
		{
			_backAndForth = b;
			_specsDirty = true;
		}

		public function get backAndForth():Boolean
		{
			return _backAndForth;
		}

		/* sets the animation pointer to a given frame and plays from there. Equivalent to ActionScript, the first frame is at 1, not 0.*/
		public function gotoAndPlay(frameNumber:uint):void
		{
			gotoFrame(frameNumber, true);
		}

		/* sets the animation pointer to a given frame and stops there. Equivalent to ActionScript, the first frame is at 1, not 0.*/
		public function gotoAndStop(frameNumber:uint):void
		{
			gotoFrame(frameNumber, false);
		}

		/* returns the current frame*/
		public function get currentFrameNumber():uint
		{
			return SpriteSheetAnimationState(_activeState).currentFrameNumber;
		}

		/* returns the total amount of frame for the current animation*/
		public function get totalFrames():uint
		{
			return SpriteSheetAnimationState(_activeState).totalFrames;
		}

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
		public function setRenderState(renderable:IRenderable, camera:Camera3D):void
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
		 * Applies the calculated time delta to the active animation state node.
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

		public function testGPUCompatibility(pass:MaterialPassBase):void
		{
		}

		public function clone():IAnimator
		{
			return new SpriteSheetAnimator(_spriteSheetAnimationSet);
		}

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

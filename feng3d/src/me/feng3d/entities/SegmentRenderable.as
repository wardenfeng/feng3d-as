package me.feng3d.entities
{
	import me.feng3d.animators.base.AnimatorBase;
	import me.feng3d.core.base.renderable.Renderable;
	import me.feng3d.materials.MaterialBase;

	/**
	 *
	 * @author feng 2015-12-30
	 */
	public class SegmentRenderable extends Renderable
	{
		private var segmentSet:SegmentSet;

		/**
		 * 创建一个可渲染对象基类
		 */
		public function SegmentRenderable(subMesh:SegmentSet)
		{
			super();

			this.segmentSet = subMesh;
//			_context3dCache.addChildBufferOwner(subMesh.context3DBufferOwner);
		}

		/**
		 * @inheritDoc
		 */
		override public function get mouseEnabled():Boolean
		{
			return segmentSet.mouseEnabled;
		}

		/**
		 * @inheritDoc
		 */
		override public function get numTriangles():uint
		{
			return segmentSet.numTriangles;
		}

		/**
		 * @inheritDoc
		 */
		override public function get sourceEntity():Entity
		{
			return segmentSet.sourceEntity;
		}

		/**
		 * @inheritDoc
		 */
		override public function get material():MaterialBase
		{
			return segmentSet.material;
		}

		/**
		 * @inheritDoc
		 */
		override public function get animator():AnimatorBase
		{
			return segmentSet.animator;
		}

		/**
		 * @inheritDoc
		 */
		override public function get castsShadows():Boolean
		{
			return segmentSet.castsShadows;
		}
	}
}


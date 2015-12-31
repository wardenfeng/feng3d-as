package me.feng3d.core.base.renderable
{
	import me.feng3d.arcane;
	import me.feng3d.animators.base.AnimatorBase;
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.entities.Entity;
	import me.feng3d.materials.MaterialBase;

	use namespace arcane;

	/**
	 * 可渲染对象基类
	 * @author feng 2015-5-27
	 */
	public class MeshRenderable extends Renderable
	{
		public var subMesh:SubMesh;

		/**
		 * 创建一个可渲染对象基类
		 */
		public function MeshRenderable(subMesh:SubMesh)
		{
			super();

			this.subMesh = subMesh;
			_context3dCache.addChildBufferOwner(subMesh.context3DBufferOwner);
		}

		/**
		 * @inheritDoc
		 */
		override public function get mouseEnabled():Boolean
		{
			return subMesh.mouseEnabled;
		}

		/**
		 * @inheritDoc
		 */
		override public function get numTriangles():uint
		{
			return subMesh.numTriangles;
		}

		/**
		 * @inheritDoc
		 */
		override public function get sourceEntity():Entity
		{
			return subMesh.sourceEntity;
		}

		/**
		 * @inheritDoc
		 */
		override public function get material():MaterialBase
		{
			return subMesh.material;
		}

		/**
		 * @inheritDoc
		 */
		override public function get animator():AnimatorBase
		{
			return subMesh.animator;
		}

		/**
		 * @inheritDoc
		 */
		override public function get castsShadows():Boolean
		{
			return subMesh.castsShadows;
		}
	}
}

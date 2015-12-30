package me.feng3d.core.base.renderable
{
	import me.feng.core.NamedAsset;
	import me.feng3d.arcane;
	import me.feng3d.animators.base.AnimatorBase;
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.core.buffer.Context3DCache;
	import me.feng3d.entities.Entity;
	import me.feng3d.fagalRE.FagalIdCenter;
	import me.feng3d.materials.MaterialBase;

	use namespace arcane;

	/**
	 * 可渲染对象基类
	 * @author feng 2015-5-27
	 */
	public class MeshRenderable extends NamedAsset implements IRenderable
	{
		private var _context3dCache:Context3DCache;
		private var subMesh:SubMesh;

		/**
		 * 创建一个可渲染对象基类
		 */
		public function MeshRenderable(subMesh:SubMesh)
		{
			this.subMesh = subMesh;

			_context3dCache = new Context3DCache();
			_context3dCache.addChildBufferOwner(subMesh.context3DBufferOwner);
		}

		/**
		 * Fagal编号中心
		 */
		public function get _():FagalIdCenter
		{
			return FagalIdCenter.instance;
		}

		/**
		 * @inheritDoc
		 */
		public function get context3dCache():Context3DCache
		{
			return _context3dCache;
		}

		/**
		 * @inheritDoc
		 */
		public function get mouseEnabled():Boolean
		{
			return subMesh.mouseEnabled;
		}

		/**
		 * @inheritDoc
		 */
		public function get numTriangles():uint
		{
			return subMesh.numTriangles;
		}

		/**
		 * @inheritDoc
		 */
		public function get sourceEntity():Entity
		{
			return subMesh.sourceEntity;
		}

		/**
		 * @inheritDoc
		 */
		public function get material():MaterialBase
		{
			return subMesh.material;
		}

		/**
		 * @inheritDoc
		 */
		public function get animator():AnimatorBase
		{
			return subMesh.animator;
		}

		/**
		 * @inheritDoc
		 */
		public function get castsShadows():Boolean
		{
			return subMesh.castsShadows;
		}
	}
}

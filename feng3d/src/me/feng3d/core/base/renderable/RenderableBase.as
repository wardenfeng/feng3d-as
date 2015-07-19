package me.feng3d.core.base.renderable
{
	import me.feng.error.AbstractMethodError;
	import me.feng3d.arcane;
	import me.feng3d.animators.IAnimator;
	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.core.buffer.Context3DCache;
	import me.feng3d.entities.Entity;
	import me.feng3d.materials.MaterialBase;

	use namespace arcane;

	/**
	 * 可渲染对象基类
	 * @author warden_feng 2015-5-27
	 */
	public class RenderableBase extends Context3DBufferOwner implements IRenderable
	{
		private var _context3dCache:Context3DCache;

		/**
		 * 创建一个可渲染对象基类
		 */
		public function RenderableBase()
		{
			_context3dCache = new Context3DCache();
			_context3dCache.addChildBufferOwner(this);
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
			throw new AbstractMethodError();
		}

		/**
		 * @inheritDoc
		 */
		public function get numTriangles():uint
		{
			throw new AbstractMethodError();
		}

		/**
		 * @inheritDoc
		 */
		public function get sourceEntity():Entity
		{
			throw new AbstractMethodError();
		}

		/**
		 * @inheritDoc
		 */
		public function get material():MaterialBase
		{
			throw new AbstractMethodError();
		}

		/**
		 * @inheritDoc
		 */
		public function get animator():IAnimator
		{
			throw new AbstractMethodError();
		}

		/**
		 * @inheritDoc
		 */
		public function get castsShadows():Boolean
		{
			throw new AbstractMethodError();
		}
	}
}

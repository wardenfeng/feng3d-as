package me.feng3d.core.base.renderable
{
	import me.feng.core.NamedAsset;
	import me.feng.error.AbstractMethodError;
	import me.feng3d.arcane;
	import me.feng3d.animators.base.AnimatorBase;
	import me.feng3d.core.buffer.Context3DCache;
	import me.feng3d.entities.Entity;
	import me.feng3d.fagalRE.FagalIdCenter;
	import me.feng3d.materials.MaterialBase;

	use namespace arcane;

	/**
	 * 可渲染对象基类
	 * @author feng 2015-5-27
	 */
	public class Renderable extends NamedAsset implements IRenderable
	{
		protected var _context3dCache:Context3DCache;

		/**
		 * 创建一个可渲染对象基类
		 */
		public function Renderable()
		{
			_context3dCache = new Context3DCache();
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
		public function get animator():AnimatorBase
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

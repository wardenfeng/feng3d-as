package me.feng3d.bounds
{
	import flash.geom.Matrix3D;
	
	import me.feng3d.core.base.Geometry;
	import me.feng3d.mathlib.Plane3D;
	import me.feng3d.primitives.WireframePrimitiveBase;
	import me.feng3d.primitives.WireframeSphere;

	/**
	 * 无空间包围盒，用于表示一直处于视锥体内或之外
	 * <p>用于某些一直处于视锥体的实体，例如方向光源、天空盒等</p>
	 * @author feng 2015-3-21
	 */
	public class NullBounds extends BoundingVolumeBase
	{
		private var _alwaysIn:Boolean;
		private var _renderable:WireframePrimitiveBase;

		/**
		 * 构建空无空间包围盒
		 * @param alwaysIn				是否总在视锥体内
		 * @param renderable			渲染实体
		 */
		public function NullBounds(alwaysIn:Boolean = true, renderable:WireframePrimitiveBase = null)
		{
			super();
			_alwaysIn = alwaysIn;
			_renderable = renderable;
			_max.x = _max.y = _max.z = Number.POSITIVE_INFINITY;
			_min.x = _min.y = _min.z = _alwaysIn ? Number.NEGATIVE_INFINITY : Number.POSITIVE_INFINITY;
		}

		/**
		 * @inheritDoc
		 */
		override protected function createBoundingRenderable():WireframePrimitiveBase
		{
			return _renderable || new WireframeSphere(100, 16, 12, 0xffffff, 0.5);
		}

		/**
		 * @inheritDoc
		 */
		override public function isInFrustum(planes:Vector.<Plane3D>, numPlanes:int):Boolean
		{
			planes = planes;
			numPlanes = numPlanes;
			return _alwaysIn;
		}

		/**
		 * @inheritDoc
		 */
		override public function fromGeometry(geometry:Geometry):void
		{
		}

		/**
		 * @inheritDoc
		 */
		override public function fromExtremes(minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number):void
		{
		}

		/**
		 * @inheritDoc
		 */
		override public function transformFrom(bounds:BoundingVolumeBase, matrix:Matrix3D):void
		{
			matrix = matrix;
			_alwaysIn = NullBounds(bounds)._alwaysIn;
		}
	}
}

package me.feng3d.primitives
{
	import flash.geom.Matrix3D;

	import me.feng.error.AbstractClassError;
	import me.feng.error.AbstractMethodError;
	import me.feng3d.arcane;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.subgeometry.SubGeometry;

	use namespace arcane;

	/**
	 * 基础网格
	 * @author feng 2014-10-11
	 */
	public class PrimitiveBase extends Geometry
	{
		protected var _geomDirty:Boolean = true;
		protected var _uvDirty:Boolean = true;

		private var _subGeometry:SubGeometry;

		public function PrimitiveBase()
		{
			_subGeometry = new SubGeometry();
			addSubGeometry(_subGeometry);
			AbstractClassError.check(this);
		}

		/**
		 * @inheritDoc
		 */
		override public function get subGeometries():Vector.<SubGeometry>
		{
			if (_geomDirty)
				updateGeometry();
			if (_uvDirty)
				updateUVs();

			return super.subGeometries;
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():Geometry
		{
			if (_geomDirty)
				updateGeometry();
			if (_uvDirty)
				updateUVs();

			return super.clone();
		}

		/**
		 * @inheritDoc
		 */
		override public function scale(scale:Number):void
		{
			if (_geomDirty)
				updateGeometry();

			super.scale(scale);
		}

		/**
		 * @inheritDoc
		 */
		override public function scaleUV(scaleU:Number = 1, scaleV:Number = 1):void
		{
			if (_uvDirty)
				updateUVs();

			super.scaleUV(scaleU, scaleV);
		}

		/**
		 * @inheritDoc
		 */
		override public function applyTransformation(transform:Matrix3D):void
		{
			if (_geomDirty)
				updateGeometry();
			super.applyTransformation(transform);
		}

		/**
		 * 创建几何体
		 */
		protected function buildGeometry(target:SubGeometry):void
		{
			throw new AbstractMethodError();
		}

		/**
		 * 创建uv
		 */
		protected function buildUVs(target:SubGeometry):void
		{
			throw new AbstractMethodError();
		}

		/**
		 * 几何体失效
		 */
		protected function invalidateGeometry():void
		{
			_geomDirty = true;
		}

		/**
		 * uv失效
		 */
		protected function invalidateUVs():void
		{
			_uvDirty = true;
		}

		/**
		 * 更新几何体
		 */
		private function updateGeometry():void
		{
			buildGeometry(_subGeometry);
			_geomDirty = false;
		}

		/**
		 * 更新uv
		 */
		private function updateUVs():void
		{
			buildUVs(_subGeometry);
			_uvDirty = false;
		}
	}
}

package me.feng3d.core.base
{
	import flash.geom.Matrix3D;
	
	import me.feng3d.arcane;
	import me.feng3d.events.GeometryEvent;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.library.assets.NamedAssetBase;

	use namespace arcane;
	
	/**
	 * 网格渲染数据缓冲
	 * @author warden_feng 2014-3-17
	 */
	public class Geometry extends NamedAssetBase implements IAsset
	{
		private var _subGeometries:Vector.<ISubGeometry>;

		public function get subGeometries():Vector.<ISubGeometry>
		{
			return _subGeometries;
		}

		public function get assetType():String
		{
			return AssetType.GEOMETRY;
		}

		public function Geometry()
		{
			_subGeometries = new Vector.<ISubGeometry>();
		}

		public function applyTransformation(transform:Matrix3D):void
		{
			var len:uint = _subGeometries.length;
			for (var i:int = 0; i < len; ++i)
				_subGeometries[i].applyTransformation(transform);
		}

		public function addSubGeometry(subGeometry:ISubGeometry):void
		{
			_subGeometries.push(subGeometry);

			subGeometry.parentGeometry = this;
			if (hasEventListener(GeometryEvent.SUB_GEOMETRY_ADDED))
				dispatchEvent(new GeometryEvent(GeometryEvent.SUB_GEOMETRY_ADDED, subGeometry));
			
			invalidateBounds(subGeometry);
		}

		public function removeSubGeometry(subGeometry:ISubGeometry):void
		{
			_subGeometries.splice(_subGeometries.indexOf(subGeometry), 1);
			subGeometry.parentGeometry = null;
			if (hasEventListener(GeometryEvent.SUB_GEOMETRY_REMOVED))
				dispatchEvent(new GeometryEvent(GeometryEvent.SUB_GEOMETRY_REMOVED, subGeometry));
			
			invalidateBounds(subGeometry);
		}

		public function clone():Geometry
		{
			var clone:Geometry = new Geometry();
			var len:uint = _subGeometries.length;
			for (var i:int = 0; i < len; ++i)
				clone.addSubGeometry(_subGeometries[i].clone());
			return clone;
		}

		public function scale(scale:Number):void
		{
			var numSubGeoms:uint = _subGeometries.length;
			for (var i:uint = 0; i < numSubGeoms; ++i)
				_subGeometries[i].scale(scale);
		}

		public function dispose():void
		{
			var numSubGeoms:uint = _subGeometries.length;

			for (var i:uint = 0; i < numSubGeoms; ++i)
			{
				var subGeom:ISubGeometry = _subGeometries[0];
				removeSubGeometry(subGeom);
				subGeom.dispose();
			}
		}

		public function scaleUV(scaleU:Number = 1, scaleV:Number = 1):void
		{
			var numSubGeoms:uint = _subGeometries.length;
			for (var i:uint = 0; i < numSubGeoms; ++i)
				_subGeometries[i].scaleUV(scaleU, scaleV);
		}

		arcane function validate():void
		{
			// To be overridden when necessary
		}
		
		arcane function invalidateBounds(subGeom:ISubGeometry):void
		{
			if (hasEventListener(GeometryEvent.BOUNDS_INVALID))
				dispatchEvent(new GeometryEvent(GeometryEvent.BOUNDS_INVALID, subGeom));
		}
	}
}

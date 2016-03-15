package me.feng3d.core.base
{
	import flash.geom.Matrix3D;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import me.feng.component.Component;
	import me.feng3d.arcane;
	import me.feng3d.components.subgeometry.SubGeometryTransformation;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.events.GeometryEvent;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;
	import me.feng3d.library.assets.NamedAsset;

	use namespace arcane;

	/**
	 * 几何体
	 * @author feng 2014-3-17
	 */
	public class Geometry extends Component implements IAsset
	{
		private var _namedAsset:NamedAsset;
		private var _subGeometries:Vector.<SubGeometry>;

		public function get subGeometries():Vector.<SubGeometry>
		{
			return _subGeometries;
		}

		public function Geometry()
		{
			_namedAsset = new NamedAsset(this, AssetType.GEOMETRY);
			_subGeometries = new Vector.<SubGeometry>();
		}

		/**
		 * 顶点个数
		 */
		public function get numVertices():uint
		{
			var _numVertices:uint;
			for (var i:int = 0; i < _subGeometries.length; i++)
			{
				_numVertices += _subGeometries[i].numVertices;
			}
			return _numVertices;
		}

		/**
		 * 应用变换矩阵
		 * @param transform 变换矩阵
		 */
		public function applyTransformation(transform:Matrix3D):void
		{
			var len:uint = _subGeometries.length;
			for (var i:int = 0; i < len; ++i)
				_subGeometries[i].applyTransformation(transform);
		}

		/**
		 * 添加子几何体
		 * @param subGeometry 子几何体
		 */
		public function addSubGeometry(subGeometry:SubGeometry):void
		{
			_subGeometries.push(subGeometry);

			subGeometry.parent = this;

			dispatchEvent(new GeometryEvent(GeometryEvent.SUB_GEOMETRY_ADDED, subGeometry));
		}

		/**
		 * 移除子几何体
		 * @param subGeometry 子几何体
		 */
		public function removeSubGeometry(subGeometry:SubGeometry):void
		{
			_subGeometries.splice(_subGeometries.indexOf(subGeometry), 1);
			subGeometry.parent = null;

			dispatchEvent(new GeometryEvent(GeometryEvent.SUB_GEOMETRY_REMOVED, subGeometry));
		}

		protected function removeAllSubGeometry():void
		{
			for (var i:int = _subGeometries.length - 1; i >= 0; i--)
			{
				removeSubGeometry(_subGeometries[i]);
			}
		}

		public function clone():Geometry
		{
			var cls:Class = getDefinitionByName(getQualifiedClassName(this)) as Class;
			var clone:Geometry = new cls();

			var len:uint = _subGeometries.length;
			for (var i:int = 0; i < len; ++i)
				clone.addSubGeometry(_subGeometries[i].clone());
			return clone;
		}

		/**
		 * 缩放几何体
		 * @param scale 缩放系数
		 */
		public function scale(scale:Number):void
		{
			var numSubGeoms:uint = _subGeometries.length;
			for (var i:uint = 0; i < numSubGeoms; ++i)
			{
				var subGeometryTransformation:SubGeometryTransformation = _subGeometries[i].getOrCreateComponentByClass(SubGeometryTransformation);
				subGeometryTransformation.scale(scale);
			}
		}

		/**
		 * 缩放uv
		 * @param scaleU u缩放系数
		 * @param scaleV v缩放系数
		 */
		public function scaleUV(scaleU:Number = 1, scaleV:Number = 1):void
		{
			var numSubGeoms:uint = _subGeometries.length;
			for (var i:uint = 0; i < numSubGeoms; ++i)
			{
				var subGeometryTransformation:SubGeometryTransformation = _subGeometries[i].getOrCreateComponentByClass(SubGeometryTransformation);
				subGeometryTransformation.scaleUV(scaleU, scaleV);
			}
		}

		public function dispose():void
		{
			var numSubGeoms:uint = _subGeometries.length;

			for (var i:uint = 0; i < numSubGeoms; ++i)
			{
				var subGeom:SubGeometry = _subGeometries[0];
				removeSubGeometry(subGeom);
				subGeom.dispose();
			}
		}

		public function get namedAsset():NamedAsset
		{
			return _namedAsset;
		}
	}
}

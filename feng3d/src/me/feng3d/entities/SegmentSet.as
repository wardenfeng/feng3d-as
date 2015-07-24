package me.feng3d.entities
{

	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.Context3DCache;
	import me.feng3d.entities.segment.SegmentSubGeometry;
	
	import me.feng3d.materials.SegmentMaterial;
	import me.feng3d.primitives.data.Segment;

	use namespace arcane;

	/**
	 * 线段集合
	 * @author warden_feng 2014-4-9
	 */
	public class SegmentSet extends Mesh implements IRenderable
	{
		private var _numIndices:uint;
		/**
		 * 数据缓存
		 */
		protected var _segmentSubGeometry:SegmentSubGeometry;

		private var _segments:Vector.<Segment> = new Vector.<Segment>();

		private var _indices:Vector.<uint>;
		private var _pointData0:Vector.<Number>;
		private var _pointData1:Vector.<Number>;
		private var _thicknessData:Vector.<Number>;
		private var _colorData:Vector.<Number>;

		/**
		 * 创建一个线段集合
		 */
		public function SegmentSet()
		{
			super();
			_segmentSubGeometry = new SegmentSubGeometry(updateSegmentData);
			material = new SegmentMaterial();
			geometry.addSubGeometry(_segmentSubGeometry);
		}

		/**
		 * 添加线段
		 * @param segment		线段数据
		 */
		public function addSegment(segment:Segment):void
		{
			_segments.push(segment);
			_segmentSubGeometry.invalid();
		}

		/**
		 * 更新线段数据
		 */
		protected function updateSegmentData():void
		{
			_indices = new Vector.<uint>();
			_pointData0 = new Vector.<Number>();
			_pointData1 = new Vector.<Number>();
			_thicknessData = new Vector.<Number>();
			_colorData = new Vector.<Number>();

			for (var i:int = 0; i < _segments.length; i++)
			{
				computeSegment(_segments[i], i);
			}

			//一条线段由4个顶点组成
			_segmentSubGeometry.numVertices = _segments.length * 4;

			_segmentSubGeometry.updateIndexData(_indices);
			_segmentSubGeometry.updatePointData0(_pointData0);
			_segmentSubGeometry.updatePointData1(_pointData1);
			_segmentSubGeometry.updateThicknessData(_thicknessData);
			_segmentSubGeometry.updateColorData(_colorData);
		}

		/**
		 * 计算线段数据
		 * @param segment 			线段数据
		 * @param segmentIndex 		线段编号
		 */
		private function computeSegment(segment:Segment, segmentIndex:int):void
		{
			//to do: add support for curve segment
			var start:Vector3D = segment.start;
			var end:Vector3D = segment.end;
			var startX:Number = start.x, startY:Number = start.y, startZ:Number = start.z;
			var endX:Number = end.x, endY:Number = end.y, endZ:Number = end.z;
			var startR:Number = segment.startR, startG:Number = segment.startG, startB:Number = segment.startB;
			var endR:Number = segment.endR, endG:Number = segment.endG, endB:Number = segment.endB;

			var point0Index:uint = segmentIndex * 4 * _segmentSubGeometry.pointData0Stride;
			var point1Index:uint = segmentIndex * 4 * _segmentSubGeometry.pointData1Stride;
			var thicknessIndex:uint = segmentIndex * 4 * _segmentSubGeometry.thicknessDataStride;
			var colorIndex:uint = segmentIndex * 4 * _segmentSubGeometry.colorDataStride;

			var t:Number = segment.thickness;

			//生成线段顶点数据
			_pointData0[point0Index++] = startX;
			_pointData0[point0Index++] = startY;
			_pointData0[point0Index++] = startZ;
			_pointData1[point1Index++] = endX;
			_pointData1[point1Index++] = endY;
			_pointData1[point1Index++] = endZ;
			_thicknessData[thicknessIndex++] = t;
			_colorData[colorIndex++] = startR;
			_colorData[colorIndex++] = startG;
			_colorData[colorIndex++] = startB;
			_colorData[colorIndex++] = 1;

			_pointData0[point0Index++] = endX;
			_pointData0[point0Index++] = endY;
			_pointData0[point0Index++] = endZ;
			_pointData1[point1Index++] = startX;
			_pointData1[point1Index++] = startY;
			_pointData1[point1Index++] = startZ;
			_thicknessData[thicknessIndex++] = -t;
			_colorData[colorIndex++] = endR;
			_colorData[colorIndex++] = endG;
			_colorData[colorIndex++] = endB;
			_colorData[colorIndex++] = 1;

			_pointData0[point0Index++] = startX;
			_pointData0[point0Index++] = startY;
			_pointData0[point0Index++] = startZ;
			_pointData1[point1Index++] = endX;
			_pointData1[point1Index++] = endY;
			_pointData1[point1Index++] = endZ;
			_thicknessData[thicknessIndex++] = -t;
			_colorData[colorIndex++] = startR;
			_colorData[colorIndex++] = startG;
			_colorData[colorIndex++] = startB;
			_colorData[colorIndex++] = 1;

			_pointData0[point0Index++] = endX;
			_pointData0[point0Index++] = endY;
			_pointData0[point0Index++] = endZ;
			_pointData1[point1Index++] = startX;
			_pointData1[point1Index++] = startY;
			_pointData1[point1Index++] = startZ;
			_thicknessData[thicknessIndex++] = t;
			_colorData[colorIndex++] = endR;
			_colorData[colorIndex++] = endG;
			_colorData[colorIndex++] = endB;
			_colorData[colorIndex++] = 1;

			//生成顶点索引数据
			var indexIndex:int = segmentIndex * 4;
			_indices.push(indexIndex, indexIndex + 1, indexIndex + 2, indexIndex + 3, indexIndex + 2, indexIndex + 1);
		}

		/**
		 * 获取线段数据
		 * @param index 		线段索引
		 * @return				线段数据
		 */
		public function getSegment(index:uint):Segment
		{
			if (index < _segments.length)
				return _segments[index];
			return null;
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateBounds():void
		{
			var len:uint;
			var v:Number;
			var index:uint;

			var minX:Number = Infinity;
			var minY:Number = Infinity;
			var minZ:Number = Infinity;
			var maxX:Number = -Infinity;
			var maxY:Number = -Infinity;
			var maxZ:Number = -Infinity;
			var vertice0:Vector.<Number> = _segmentSubGeometry.vertexPositionData;

			index = 0;
			len = vertice0.length;

			while (index < len)
			{
				v = vertice0[index++];
				if (v < minX)
					minX = v;
				else if (v > maxX)
					maxX = v;

				v = vertice0[index++];
				if (v < minY)
					minY = v;
				else if (v > maxY)
					maxY = v;

				v = vertice0[index++];
				if (v < minZ)
					minZ = v;
				else if (v > maxZ)
					maxZ = v;

				index += 8;
			}

			if (minX != Infinity)
				_bounds.fromExtremes(minX, minY, minZ, maxX, maxY, maxZ);

			else
			{
				var min:Number = .5;
				_bounds.fromExtremes(-min, -min, -min, min, min, min);
			}

			_boundsInvalid = false;
		}

		/**
		 * 移除所有线段
		 */
		public function removeAllSegments():void
		{
			segments.length = 0;
			_segmentSubGeometry.invalid();
		}

		/**
		 * 线段列表
		 */
		public function get segments():Vector.<Segment>
		{
			return _segments;
		}

		/**
		 * @inheritDoc
		 */
		public function get context3dCache():Context3DCache
		{
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function get numTriangles():uint
		{
			return _numIndices / 3;
		}
	}
}

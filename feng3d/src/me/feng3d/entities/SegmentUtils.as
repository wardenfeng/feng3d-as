package me.feng3d.entities
{
	import flash.geom.Vector3D;

	import me.feng3d.entities.segment.SegmentSubGeometry;
	import me.feng3d.primitives.data.Segment;

	/**
	 *
	 * @author feng 2015-12-30
	 */
	public class SegmentUtils
	{
		private const LIMIT:uint = 3 * 0xFFFF;

		/**
		 * 数据缓存
		 */
		protected var _segmentSubGeometry:SegmentSubGeometry;

		private var _indices:Vector.<uint>;
		private var _pointData0:Vector.<Number>;
		private var _pointData1:Vector.<Number>;
		private var _thicknessData:Vector.<Number>;
		private var _colorData:Vector.<Number>;

		public function SegmentUtils()
		{
		}

		public static function getSegmentSubGeometrys(_segments:Vector.<Segment>):SegmentSubGeometry
		{
			var segmentUtils:SegmentUtils = new SegmentUtils();
			var _segmentSubGeometry:SegmentSubGeometry = segmentUtils.getSegmentSubGeometry(_segments);
			return _segmentSubGeometry;
		}

		public function getSegmentSubGeometry(_segments:Vector.<Segment>):SegmentSubGeometry
		{
			_segmentSubGeometry = new SegmentSubGeometry();

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

			return _segmentSubGeometry;
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
	}
}

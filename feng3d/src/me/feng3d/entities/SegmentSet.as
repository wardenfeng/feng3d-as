package me.feng3d.entities
{

	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.primitives.data.Segment;
	import me.feng3d.materials.SegmentMaterial;
	import me.feng3d.entities.segment.SegmentSubGeometry;

	use namespace arcane;

	/**
	 * 线段
	 * @author warden_feng 2014-4-9
	 */
	public class SegmentSet extends Mesh
	{
		/**
		 * 数据缓冲
		 */
		protected var _segmentSubGeometry:SegmentSubGeometry;

		private var _segments:Vector.<Segment> = new Vector.<Segment>();

		public function SegmentSet()
		{
			super();
			_segmentSubGeometry = new SegmentSubGeometry(updateSegmentData);
			material = new SegmentMaterial();
			geometry.addSubGeometry(_segmentSubGeometry);
		}

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
			var _vertices:Vector.<Number> = new Vector.<Number>();
			var _indices:Vector.<uint> = new Vector.<uint>();

			for (var i:int = 0; i < _segments.length; i++)
			{
				computeSegment(_segments[i], _vertices, _indices, i);
			}

			_segmentSubGeometry.updateVertexData(_vertices);
			_segmentSubGeometry.updateIndexData(_indices);
		}

		/**
		 * 计算线段数据
		 * @param segment 线段数据
		 * @param vertices 顶点数据
		 * @param indices 顶点索引
		 * @param segmentIndex 线段编号
		 */
		private function computeSegment(segment:Segment, vertices:Vector.<Number>, indices:Vector.<uint>, segmentIndex:int):void
		{
			//to do: add support for curve segment
			var start:Vector3D = segment.start;
			var end:Vector3D = segment.end;
			var startX:Number = start.x, startY:Number = start.y, startZ:Number = start.z;
			var endX:Number = end.x, endY:Number = end.y, endZ:Number = end.z;
			var startR:Number = segment.startR, startG:Number = segment.startG, startB:Number = segment.startB;
			var endR:Number = segment.endR, endG:Number = segment.endG, endB:Number = segment.endB;

			var verticeIndex:uint = segmentIndex * 4 * _segmentSubGeometry.vertexStride;
			var t:Number = segment.thickness;

			//生成线段顶点数据
			vertices[verticeIndex++] = startX;
			vertices[verticeIndex++] = startY;
			vertices[verticeIndex++] = startZ;
			vertices[verticeIndex++] = endX;
			vertices[verticeIndex++] = endY;
			vertices[verticeIndex++] = endZ;
			vertices[verticeIndex++] = t;
			vertices[verticeIndex++] = startR;
			vertices[verticeIndex++] = startG;
			vertices[verticeIndex++] = startB;
			vertices[verticeIndex++] = 1;

			vertices[verticeIndex++] = endX;
			vertices[verticeIndex++] = endY;
			vertices[verticeIndex++] = endZ;
			vertices[verticeIndex++] = startX;
			vertices[verticeIndex++] = startY;
			vertices[verticeIndex++] = startZ;
			vertices[verticeIndex++] = -t;
			vertices[verticeIndex++] = endR;
			vertices[verticeIndex++] = endG;
			vertices[verticeIndex++] = endB;
			vertices[verticeIndex++] = 1;

			vertices[verticeIndex++] = startX;
			vertices[verticeIndex++] = startY;
			vertices[verticeIndex++] = startZ;
			vertices[verticeIndex++] = endX;
			vertices[verticeIndex++] = endY;
			vertices[verticeIndex++] = endZ;
			vertices[verticeIndex++] = -t;
			vertices[verticeIndex++] = startR;
			vertices[verticeIndex++] = startG;
			vertices[verticeIndex++] = startB;
			vertices[verticeIndex++] = 1;

			vertices[verticeIndex++] = endX;
			vertices[verticeIndex++] = endY;
			vertices[verticeIndex++] = endZ;
			vertices[verticeIndex++] = startX;
			vertices[verticeIndex++] = startY;
			vertices[verticeIndex++] = startZ;
			vertices[verticeIndex++] = t;
			vertices[verticeIndex++] = endR;
			vertices[verticeIndex++] = endG;
			vertices[verticeIndex++] = endB;
			vertices[verticeIndex++] = 1;

			//生成顶点索引数据
			var indexIndex:int = segmentIndex * 4;
			indices.push(indexIndex, indexIndex + 1, indexIndex + 2, indexIndex + 3, indexIndex + 2, indexIndex + 1);
		}

		/**
		 * 获取线段数据
		 * @param index 线段索引
		 * @return
		 */
		public function getSegment(index:uint):Segment
		{
			if (index < _segments.length)
				return _segments[index];
			return null;
		}

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
			var vertice0:Vector.<Number> = _segmentSubGeometry.vertexData;

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
		
		public function removeAllSegments():void
		{
			segments.length = 0;
			_segmentSubGeometry.invalid();
		}

		/** 线段列表 */
		public function get segments():Vector.<Segment>
		{
			return _segments;
		}
	}
}

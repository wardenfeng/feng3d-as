package me.feng3d.entities
{
	import me.feng3d.core.base.Geometry;
	import me.feng3d.entities.segment.SegmentSubGeometry;
	import me.feng3d.primitives.data.Segment;


	/**
	 *
	 * @author feng 2015-12-30
	 */
	public class SegmentGeometry extends Geometry
	{
		private var _segments:Vector.<Segment> = new Vector.<Segment>();

		public function SegmentGeometry()
		{
			super();
		}

		/**
		 * 添加线段
		 * @param segment		线段数据
		 */
		public function addSegment(segment:Segment, needUpdateGeometry:Boolean = true):void
		{
			_segments.push(segment);

			if (needUpdateGeometry)
			{
				updateGeometry();
			}
		}

		public function updateGeometry():void
		{
			removeAllSubGeometry();

			var _segmentSubGeometry:SegmentSubGeometry = SegmentUtils.getSegmentSubGeometrys(_segments);
			addSubGeometry(_segmentSubGeometry);
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
		 * 移除所有线段
		 */
		public function removeAllSegments():void
		{
			segments.length = 0;

			removeAllSubGeometry();
		}

		/**
		 * 线段列表
		 */
		public function get segments():Vector.<Segment>
		{
			return _segments;
		}
	}
}

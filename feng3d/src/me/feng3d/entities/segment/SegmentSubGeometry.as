package me.feng3d.entities.segment
{

	import me.feng3d.core.base.subgeometry.SubGeometry;

	/**
	 * 线段渲染数据缓存
	 * @author feng 2014-5-9
	 */
	public class SegmentSubGeometry extends SubGeometry
	{
		public function SegmentSubGeometry()
		{
			super();
		}

		override protected function initBuffers():void
		{
			super.initBuffers();

			mapVABuffer(_.segmentStart_va_3, 3);
			mapVABuffer(_.segmentEnd_va_3, 3);
			mapVABuffer(_.segmentThickness_va_1, 1);
			mapVABuffer(_.segmentColor_va_4, 4);
		}

		override public function get vertexPositionData():Vector.<Number>
		{
			return pointData0;
		}

		public function get pointData0():Vector.<Number>
		{
			var data:Vector.<Number> = getVAData(_.segmentStart_va_3);
			return data;
		}

		public function get pointData1():Vector.<Number>
		{
			var data:Vector.<Number> = getVAData(_.segmentEnd_va_3);
			return data;
		}

		public function get thicknessData():Vector.<Number>
		{
			var data:Vector.<Number> = getVAData(_.segmentThickness_va_1);
			return data;
		}

		public function get colorData():Vector.<Number>
		{
			var data:Vector.<Number> = getVAData(_.segmentColor_va_4);
			return data;
		}

		public function get pointData0Stride():int
		{
			return 3;
		}

		public function get pointData1Stride():int
		{
			return 3;
		}

		public function get thicknessDataStride():int
		{
			return 1;
		}

		public function get colorDataStride():int
		{
			return 4;
		}

		public function updatePointData0(value:Vector.<Number>):void
		{
			setVAData(_.segmentStart_va_3, value);
		}

		public function updatePointData1(value:Vector.<Number>):void
		{
			setVAData(_.segmentEnd_va_3, value);
		}

		public function updateThicknessData(value:Vector.<Number>):void
		{
			setVAData(_.segmentThickness_va_1, value);
		}

		public function updateColorData(value:Vector.<Number>):void
		{
			setVAData(_.segmentColor_va_4, value);
		}

	}
}

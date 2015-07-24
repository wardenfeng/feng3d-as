package me.feng3d.entities.segment
{

	import me.feng3d.core.base.subgeometry.SubGeometry;
	

	/**
	 * 线段渲染数据缓存
	 * @author warden_feng 2014-5-9
	 */
	public class SegmentSubGeometry extends SubGeometry
	{
		/** 更新回调函数 */
		protected var _updateFunc:Function;

		/** 线段数据是否脏了 */
		private var _segmentDataDirty:Boolean = true;

		public function SegmentSubGeometry(updateFunc:Function)
		{
			super();
			_updateFunc = updateFunc;
		}

		override protected function initBuffers():void
		{
			super.initBuffers();

			mapVABuffer(_.segmentStart_va_3, 3);
			mapVABuffer(_.segmentEnd_va_3, 3);
			mapVABuffer(_.segmentThickness_va_1, 1);
			mapVABuffer(_.segmentColor_va_4, 4);
		}

		override public function get indices():Vector.<uint>
		{
			doUpdateFunc();
			return _indices;
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

		override protected function updateVAdata(dataTypeId:String):void
		{
			doUpdateFunc();
			super.updateVAdata(dataTypeId);
		}

		protected function doUpdateFunc():void
		{
			if (_updateFunc != null && _segmentDataDirty)
			{
				_segmentDataDirty = false;
				_updateFunc();
			}
		}

		public function invalid():void
		{
			_segmentDataDirty = true;

			invalidVAData(_.segmentStart_va_3);
			invalidVAData(_.segmentEnd_va_3);
			invalidVAData(_.segmentThickness_va_1);
			invalidVAData(_.segmentColor_va_4);
		}
	}
}



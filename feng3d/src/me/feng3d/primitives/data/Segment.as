package me.feng3d.primitives.data
{
	import flash.geom.Vector3D;

	/**
	 * 单条线段数据
	 * @author feng 2014-4-9
	 */
	public class Segment
	{
		protected var _thickness:Number;
		protected var _start:Vector3D;
		protected var _end:Vector3D;
		protected var _startR:Number;
		protected var _startG:Number;
		protected var _startB:Number;
		protected var _endR:Number;
		protected var _endG:Number;
		protected var _endB:Number;

		private var _startColor:uint;
		private var _endColor:uint;

		/**
		 * 创建一条线段数据
		 * @param start 起点坐标
		 * @param end 终点坐标
		 * @param colorStart 起点颜色
		 * @param colorEnd 终点颜色
		 * @param thickness 线段厚度
		 */		
		public function Segment(start:Vector3D, end:Vector3D, colorStart:uint = 0x333333, colorEnd:uint = 0x333333, thickness:Number = 1):void
		{
			_thickness = thickness * .5;
			_start = start;
			_end = end;
			startColor = colorStart;
			endColor = colorEnd;
		}

		/**
		 * 更新线段信息
		 * @param start 起点坐标
		 * @param end 终点坐标
		 * @param colorStart 起点颜色
		 * @param colorEnd 终点颜色
		 * @param thickness 线段厚度
		 */		
		public function updateSegment(start:Vector3D, end:Vector3D, colorStart:uint = 0x333333, colorEnd:uint = 0x333333, thickness:Number = 1):void
		{
			_start = start;
			_end = end;

			if (_startColor != colorStart)
				startColor = colorStart;

			if (_endColor != colorEnd)
				endColor = colorEnd;

			_thickness = thickness * .5;

		}

		/**
		 * 起点坐标
		 */
		public function get start():Vector3D
		{
			return _start;
		}

		public function set start(value:Vector3D):void
		{
			_start = value;

		}

		/**
		 * 终点坐标
		 */
		public function get end():Vector3D
		{
			return _end;
		}

		public function set end(value:Vector3D):void
		{
			_end = value;
		}

		/**
		 * 线段厚度
		 */
		public function get thickness():Number
		{
			return _thickness * 2;
		}

		public function set thickness(value:Number):void
		{
			_thickness = value * .5;

		}

		/**
		 * 起点颜色
		 */
		public function get startColor():uint
		{
			return _startColor;
		}

		public function set startColor(color:uint):void
		{
			_startR = ((color >> 16) & 0xff) / 255;
			_startG = ((color >> 8) & 0xff) / 255;
			_startB = (color & 0xff) / 255;

			_startColor = color;
		}

		/**
		 * 终点颜色
		 */
		public function get endColor():uint
		{
			return _endColor;
		}

		public function set endColor(color:uint):void
		{
			_endR = ((color >> 16) & 0xff) / 255;
			_endG = ((color >> 8) & 0xff) / 255;
			_endB = (color & 0xff) / 255;

			_endColor = color;
		}

		public function dispose():void
		{
			_start = null;
			_end = null;
		}

		public function get startR():Number
		{
			return _startR;
		}

		public function get startG():Number
		{
			return _startG;
		}

		public function get startB():Number
		{
			return _startB;
		}

		public function get endR():Number
		{
			return _endR;
		}

		public function get endG():Number
		{
			return _endG;
		}

		public function get endB():Number
		{
			return _endB;
		}
	}
}

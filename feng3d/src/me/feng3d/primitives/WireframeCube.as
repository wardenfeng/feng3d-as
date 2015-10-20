package me.feng3d.primitives
{
	import flash.geom.Vector3D;

	/**
	 * 线框立方体
	 * @author feng 2014-4-27
	 */
	public class WireframeCube extends WireframePrimitiveBase
	{
		private var _cubeWidth:Number;
		private var _cubeHeight:Number;
		private var _cubeDepth:Number;

		/**
		 * @param width X轴方向宽度
		 * @param height Y轴方向高度
		 * @param depth Z轴方向深度
		 * @param color 线条颜色
		 * @param thickness 线条厚度
		 */
		public function WireframeCube(width:Number = 100, height:Number = 100, depth:Number = 100, color:uint = 0xFFFFFF, thickness:Number = 1)
		{
			super(color, thickness);
			
			cubeWidth = width;
			cubeHeight = height;
			cubeDepth = depth;
		}

		/**
		 * The size of the cube along its X-axis.
		 */
		public function get cubeWidth():Number
		{
			return _cubeWidth;
		}

		public function set cubeWidth(value:Number):void
		{
			_cubeWidth = value;
			_segmentSubGeometry.invalid();
		}

		/**
		 * The size of the cube along its Y-axis.
		 */
		public function get cubeHeight():Number
		{
			return _cubeHeight;
		}

		public function set cubeHeight(value:Number):void
		{
			if (value <= 0)
				throw new Error("Value needs to be greater than 0");
			_cubeHeight = value;
			_segmentSubGeometry.invalid();
		}

		/**
		 * The size of the cube along its Z-axis.
		 */
		public function get cubeDepth():Number
		{
			return _cubeDepth;
		}

		public function set cubeDepth(value:Number):void
		{
			_cubeDepth = value;
			_segmentSubGeometry.invalid();
		}

		/**
		 * @inheritDoc
		 */
		override protected function buildGeometry():void
		{
			removeAllSegments();
			
			var v0:Vector3D = new Vector3D();
			var v1:Vector3D = new Vector3D();
			var hw:Number = _cubeWidth * .5;
			var hh:Number = _cubeHeight * .5;
			var hd:Number = _cubeDepth * .5;

			v0.x = -hw;
			v0.y = hh;
			v0.z = -hd;
			v1.x = -hw;
			v1.y = -hh;
			v1.z = -hd;

			updateOrAddSegment(0, v0, v1);
			v0.z = hd;
			v1.z = hd;
			updateOrAddSegment(1, v0, v1);
			v0.x = hw;
			v1.x = hw;
			updateOrAddSegment(2, v0, v1);
			v0.z = -hd;
			v1.z = -hd;
			updateOrAddSegment(3, v0, v1);

			v0.x = -hw;
			v0.y = -hh;
			v0.z = -hd;
			v1.x = hw;
			v1.y = -hh;
			v1.z = -hd;
			updateOrAddSegment(4, v0, v1);
			v0.y = hh;
			v1.y = hh;
			updateOrAddSegment(5, v0, v1);
			v0.z = hd;
			v1.z = hd;
			updateOrAddSegment(6, v0, v1);
			v0.y = -hh;
			v1.y = -hh;
			updateOrAddSegment(7, v0, v1);

			v0.x = -hw;
			v0.y = -hh;
			v0.z = -hd;
			v1.x = -hw;
			v1.y = -hh;
			v1.z = hd;
			updateOrAddSegment(8, v0, v1);
			v0.y = hh;
			v1.y = hh;
			updateOrAddSegment(9, v0, v1);
			v0.x = hw;
			v1.x = hw;
			updateOrAddSegment(10, v0, v1);
			v0.y = -hh;
			v1.y = -hh;
			updateOrAddSegment(11, v0, v1);
		}

	}
}

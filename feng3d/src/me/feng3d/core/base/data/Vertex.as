package me.feng3d.core.base.data
{

	/**
	 * 顶点
	 */
	public class Vertex
	{
		private var _x:Number;
		private var _y:Number;
		private var _z:Number;
		private var _index:uint;

		/**
		 *
		 * @param x X轴坐标
		 * @param y Y轴坐标
		 * @param z Z轴坐标
		 * @param index 顶点索引
		 */
		public function Vertex(x:Number = 0, y:Number = 0, z:Number = 0, index:uint = 0)
		{
			_x = x;
			_y = y;
			_z = z;
			_index = index;
		}

		/**
		 * To define/store the index of value object
		 * @param    ind        The index
		 */
		public function set index(ind:uint):void
		{
			_index = ind;
		}

		public function get index():uint
		{
			return _index;
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function get z():Number
		{
			return _z;
		}

		public function set z(value:Number):void
		{
			_z = value;
		}

		public function clone():Vertex
		{
			return new Vertex(_x, _y, _z);
		}

		public function toString():String
		{
			return _x + "," + _y + "," + _z;
		}

	}
}

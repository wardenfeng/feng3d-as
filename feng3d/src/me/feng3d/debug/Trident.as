package me.feng3d.debug
{
	import flash.geom.Vector3D;

	import me.feng3d.entities.SegmentSet;
	import me.feng3d.primitives.data.Segment;

	/**
	 * 坐标系,三叉戟
	 * @param length 长度
	 * @param showLetters 显示字母
	 */
	public class Trident extends SegmentSet
	{
		public function Trident(length:Number = 100, showLetters:Boolean = true):void
		{
			buildTrident(Math.abs((length == 0) ? 10 : length), showLetters);
		}

		private function buildTrident(length:Number, showLetters:Boolean):void
		{
			var scaleH:Number = length / 10;
			var scaleW:Number = length / 20;
			var scl1:Number = scaleW * 1.5;
			var scl2:Number = scaleH * 3;
			var scl3:Number = scaleH * 2;
			var scl4:Number = scaleH * 3.4;
			var cross:Number = length + (scl3) + (((length + scl4) - (length + scl3)) / 3 * 2);

			var arr:Array = [ //
				[new Vector3D(), new Vector3D(length, 0, 0), 0x880000, 0xff0000, 1], //X轴
				//X
				[new Vector3D(length + scl2, scl1, 0), new Vector3D(length + scl3, -scl1, 0), 0xff0000, 0xff0000, 1], //
				[new Vector3D(length + scl3, scl1, 0), new Vector3D(length + scl2, -scl1, 0), 0xff0000, 0xff0000, 1], //

				[new Vector3D(), new Vector3D(0, length, 0), 0x008800, 0x00ff00, 1], //Y轴
				//Y
				[new Vector3D(-scaleW * 1.2, length + scl4, 0), new Vector3D(0, cross, 0), 0x00ff00, 0x00ff00, 1], //
				[new Vector3D(scaleW * 1.2, length + scl4, 0), new Vector3D(0, cross, 0), 0x00ff00, 0x00ff00, 1], //
				[new Vector3D(0, cross, 0), new Vector3D(0, length + scl3, 0), 0x00ff00, 0x00ff00, 1], //

				[new Vector3D(), new Vector3D(0, 0, length), 0x000088, 0x0000ff, 1], //Z轴
				//Z
				[new Vector3D(0, scl1, length + scl2), new Vector3D(0, scl1, length + scl3), 0x0000ff, 0x0000ff, 1], //
				[new Vector3D(0, -scl1, length + scl2), new Vector3D(0, -scl1, length + scl3), 0x0000ff, 0x0000ff, 1], //
				[new Vector3D(0, -scl1, length + scl3), new Vector3D(0, scl1, length + scl2), 0x0000ff, 0x0000ff, 1], //
				];

			var segmentX:Segment;
			for (var i:int = 0; i < arr.length; i++)
			{
				segmentX = new Segment(arr[i][0], arr[i][1], arr[i][2], arr[i][3], arr[i][4]);
				segmentGeometry.addSegment(segmentX);
			}

		}

	}
}

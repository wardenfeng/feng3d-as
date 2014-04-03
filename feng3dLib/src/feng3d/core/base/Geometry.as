package feng3d.core.base
{

	/**
	 * 几何形体
	 * @author warden_feng 2014-3-17
	 */
	public class Geometry
	{
		public var rawIndexBuffer:Vector.<uint>;
		public var rawPositionsBuffer:Vector.<Number>;
		public var rawUvBuffer:Vector.<Number>;
		public var rawNormalsBuffer:Vector.<Number>;
		public var rawColorsBuffer:Vector.<Number>;

		public function Geometry()
		{

		}

		public function updateData(dataObj:Object):void
		{
			rawIndexBuffer = dataObj.rawIndexBuffer;
			rawPositionsBuffer = dataObj.rawPositionsBuffer;
			rawUvBuffer = dataObj.rawUvBuffer;
			rawColorsBuffer = dataObj.rawColorsBuffer;
		}

		public function get indexBufferCount():int
		{
			return rawIndexBuffer.length / 3;
		}

		public function clone():Geometry
		{
			var geometry:Geometry = new Geometry();

			geometry.rawIndexBuffer = rawIndexBuffer;
			geometry.rawPositionsBuffer = rawPositionsBuffer;
			geometry.rawUvBuffer = rawUvBuffer;
			geometry.rawColorsBuffer = rawColorsBuffer;
			return geometry;
		}
	}
}

package colorTerrain
{
	import base.BaseGeometry;

	import fagal.Context3DBufferTypeID;

	/**
	 *
	 * @author warden_feng 2015-5-14
	 */
	public class ColorTerrainGeometry extends BaseGeometry
	{
		public function ColorTerrainGeometry()
		{
			super();
		}

		public function get vertexUVData():Vector.<Number>
		{
			return getVAData(Context3DBufferTypeID.UV_VA_2);
		}

		public function set vertexUVData(value:Vector.<Number>):void
		{
			setVAData(Context3DBufferTypeID.UV_VA_2, value);
		}

		override protected function initBuffers():void
		{
			mapVABuffer(Context3DBufferTypeID.UV_VA_2, 2);
			super.initBuffers();
		}
	}
}

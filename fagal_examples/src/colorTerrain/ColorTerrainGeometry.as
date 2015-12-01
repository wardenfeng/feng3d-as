package colorTerrain
{
	import base.BaseGeometry;

	/**
	 *
	 * @author feng 2015-5-14
	 */
	public class ColorTerrainGeometry extends BaseGeometry
	{
		public function ColorTerrainGeometry()
		{
			super();
		}

		public function get vertexUVData():Vector.<Number>
		{
			return getVAData(_.uv_va_2);
		}

		public function set vertexUVData(value:Vector.<Number>):void
		{
			setVAData(_.uv_va_2, value);
		}

		override protected function initBuffers():void
		{
			mapVABuffer(_.uv_va_2, 2);
			super.initBuffers();
		}
	}
}

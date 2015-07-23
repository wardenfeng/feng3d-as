package colorTerrain
{
	import base.BaseMaterial;

	import fagal.F_colorTerrain;
	import fagal.V_colorTerrain;

	import me.feng3d.core.buffer.context3d.FSArrayBuffer;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 *
	 * @author warden_feng 2015-5-14
	 */
	public class ColorTerrainMaterial extends BaseMaterial
	{
		private var _splats:Array;

		public function ColorTerrainMaterial(splats:Array)
		{
			_splats = splats;
			super();
		}

		override protected function initBuffers():void
		{
			mapContext3DBuffer(_.terrainTextures_fs_array, updateTerrainTextureBuffer);
			super.initBuffers();
		}

		private function updateTerrainTextureBuffer(terrainTextureBufferArr:FSArrayBuffer):void
		{
			terrainTextureBufferArr.update(_splats);
		}

		override protected function updateProgramBuffer(programBuffer:ProgramBuffer):void
		{
			var result:Object = FagalRE.run(V_colorTerrain, F_colorTerrain);

			//上传程序
			programBuffer.update(result.vertexCode, result.fragmentCode);
		}
	}
}

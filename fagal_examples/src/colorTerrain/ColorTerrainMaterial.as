package colorTerrain
{
	import base.BaseMaterial;

	import fagal.F_colorTerrain;
	import fagal.V_colorTerrain;

	import me.feng3d.core.buffer.context3d.FSArrayBuffer;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.fagalRE.FagalShaderResult;

	/**
	 * 颜色地形材质
	 * @author feng 2015-5-14
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
			var result:FagalShaderResult = FagalRE.runShader(V_colorTerrain, F_colorTerrain);

			//上传程序
			programBuffer.update(result.vertexCode, result.fragmentCode);
		}
	}
}

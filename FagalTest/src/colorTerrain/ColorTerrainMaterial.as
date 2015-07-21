package colorTerrain
{
	import com.junkbyte.console.Cc;

	import base.BaseMaterial;

	import fagal.Context3DBufferTypeID;
	import fagal.F_colorTerrain;
	import fagal.V_colorTerrain;

	import me.feng3d.core.buffer.context3d.FSArrayBuffer;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.fagal.runFagalMethod;

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
			mapContext3DBuffer(Context3DBufferTypeID.TERRAINTEXTURES_FS_ARRAY, updateTerrainTextureBuffer);
			super.initBuffers();
		}

		private function updateTerrainTextureBuffer(terrainTextureBufferArr:FSArrayBuffer):void
		{
			terrainTextureBufferArr.update(_splats);
		}

		override protected function updateProgramBuffer(programBuffer:ProgramBuffer):void
		{
			//运行顶点渲染函数
			var vertexCode:String = runFagalMethod(V_colorTerrain);

			//运行片段渲染函数
			var fragmentCode:String = runFagalMethod(F_colorTerrain);

			Cc.info("Compiling AGAL Code:");
			Cc.info("--------------------");
			Cc.info(vertexCode);
			Cc.info("--------------------");
			Cc.info(fragmentCode);

			//上传程序
			programBuffer.update(vertexCode, fragmentCode);
		}
	}
}

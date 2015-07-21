package colorMap
{
	import com.junkbyte.console.Cc;

	import base.BaseMaterial;

	import fagal.Context3DBufferTypeID;
	import fagal.F_colorMap;
	import fagal.V_colorMap;

	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.fagal.runFagalMethod;

	/**
	 *
	 * @author warden_feng 2015-5-14
	 */
	public class ColorMapMaterial extends BaseMaterial
	{
		/**
		 * 通用数据
		 */
		protected const commonsData:Vector.<Number> = new Vector.<Number>(4);

		public function ColorMapMaterial()
		{
			super();
		}

		override protected function initBuffers():void
		{
			mapContext3DBuffer(Context3DBufferTypeID.COMMONSDATA_VC_VECTOR, updateCommonsDataBuffer);
			super.initBuffers();
		}

		/**
		 * 更新通用数据
		 */
		protected function updateCommonsDataBuffer(vcVectorBuffer:VCVectorBuffer):void
		{
			commonsData[0] = 2;
			commonsData[1] = 1;
			commonsData[2] = 0;
			commonsData[3] = 0;
			vcVectorBuffer.update(commonsData);
		}

		override protected function updateProgramBuffer(programBuffer:ProgramBuffer):void
		{
			//运行顶点渲染函数
			var vertexCode:String = runFagalMethod(V_colorMap);

			//运行片段渲染函数
			var fragmentCode:String = runFagalMethod(F_colorMap);

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

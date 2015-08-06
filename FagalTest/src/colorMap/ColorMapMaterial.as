package colorMap
{
	import base.BaseMaterial;

	import fagal.F_colorMap;
	import fagal.V_colorMap;

	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 颜色映射材质
	 * @author warden_feng 2015-5-14
	 */
	public class ColorMapMaterial extends BaseMaterial
	{
		/**
		 * 通用数据
		 */
		protected const commonsData:Vector.<Number> = new Vector.<Number>(4);

		/**
		 * 创建一个颜色映射材质
		 */
		public function ColorMapMaterial()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			mapContext3DBuffer(_.commonsData_vc_vector, updateCommonsDataBuffer);
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

		/**
		 * @inheritDoc
		 */
		override protected function updateProgramBuffer(programBuffer:ProgramBuffer):void
		{
			var result:Object = FagalRE.runShader(V_colorMap, F_colorMap);

			//上传程序
			programBuffer.update(result.vertexCode, result.fragmentCode);
		}
	}
}

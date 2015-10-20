package base
{
	import flash.geom.Matrix3D;

	import fagal.F_baseShader;
	import fagal.V_baseShader;

	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.fagalRE.FagalShaderResult;

	/**
	 * 基础材质
	 * @author warden_feng 2014-10-27
	 */
	public class BaseMaterial extends Context3DBufferOwner
	{
		protected var modelViewProjection:Matrix3D = new Matrix3D();

		private var mre:FagalRE = FagalRE.instance;

		private var _shaderParams:ShaderParams;

		public function get shaderParams():ShaderParams
		{
			return _shaderParams ||= new ShaderParams();
		}

		public function BaseMaterial()
		{
			super();
		}

		protected override function initBuffers():void
		{
			mapContext3DBuffer(_.projection_vc_matrix, updateProjectionBuffer);
			mapContext3DBuffer(_.program, updateProgramBuffer);
		}

		public function render(viewMatrix:Matrix3D):void
		{
			modelViewProjection = viewMatrix;
			markBufferDirty(_.projection_vc_matrix);
		}

		/**
		 * 更新投影矩阵
		 */
		protected function updateProjectionBuffer(projectionBuffer:VCMatrixBuffer):void
		{
			projectionBuffer.update(modelViewProjection, true);
		}

		/**
		 * 更新（编译）渲染程序
		 */
		protected function updateProgramBuffer(programBuffer:ProgramBuffer):void
		{
			var result:FagalShaderResult = FagalRE.runShader(V_baseShader, F_baseShader);

			//上传程序
			programBuffer.update(result.vertexCode, result.fragmentCode);
		}
	}
}

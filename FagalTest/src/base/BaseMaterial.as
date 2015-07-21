package base
{
	import com.junkbyte.console.Cc;

	import flash.geom.Matrix3D;

	import fagal.Context3DBufferTypeID;
	import fagal.F_baseShader;
	import fagal.V_baseShader;

	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.fagal.runFagalMethod;
	import me.feng3d.fagal.methods.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;

	/**
	 *
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
			mapContext3DBuffer(Context3DBufferTypeID.PROJECTION_VC_MATRIX, updateProjectionBuffer);
			mapContext3DBuffer(Context3DBufferTypeID.PROGRAM, updateProgramBuffer);
		}

		public function render(viewMatrix:Matrix3D):void
		{
			modelViewProjection = viewMatrix;
			markBufferDirty(Context3DBufferTypeID.PROJECTION_VC_MATRIX);
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
			//运行顶点渲染函数
			var vertexCode:String = runFagalMethod(V_baseShader);

			//运行片段渲染函数
			var fragmentCode:String = runFagalMethod(F_baseShader);

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

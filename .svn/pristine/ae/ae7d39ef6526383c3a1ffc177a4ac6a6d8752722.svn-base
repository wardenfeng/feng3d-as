package feng3d
{
	import com.adobe.utils.AGALMiniAssembler;

	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;

	/**
	 *
	 * @author warden_feng 2014-3-14
	 */
	public class ShaderProgram
	{
		// the compiled shaders used to render our mesh
		public var shaderProgram1:Program3D;

		public function ShaderProgram()
		{
		}

		// create four different shaders
		public function initShaders(context3D:Context3D):void
		{
			// A simple vertex shader which does a 3D transformation
			// for simplicity, it is used by all four shaders
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble(Context3DProgramType.VERTEX,
				// 4x4 matrix multiply to get camera angle	
				"m44 op, va0, vc0\n" +
				// tell fragment shader about XYZ
				"mov v0, va0\n" +
				// tell fragment shader about UV
				"mov v1, va1\n");

			// textured using UV coordinates
			var fragmentShaderAssembler1:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShaderAssembler1.assemble(Context3DProgramType.FRAGMENT,
				// grab the texture color from texture 0 
				// and uv coordinates from varying register 1
				// and store the interpolated value in ft0
				"tex ft0, v1, fs0 <2d,linear,repeat,miplinear>\n" +
				// move this value to the output color
				"mov oc, ft0\n");

			// combine shaders into a program which we then upload to the GPU
			shaderProgram1 = context3D.createProgram();
			shaderProgram1.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler1.agalcode);
		}
	}
}

package shader
{
	import me.feng3d.fagal.fragment.F_Segment;
	import me.feng3d.fagal.runFagalMethod;
	import me.feng3d.fagal.vertex.V_Segment;

	/**
	 * 测试线段渲染程序
	 * @author warden_feng 2014-10-29
	 */
	public class SegmentShaderTest extends TestBase
	{
		public function SegmentShaderTest()
		{
			//运行顶点渲染函数
			var vertexCode:String = runFagalMethod(V_Segment);

			//运行片段渲染函数
			var fragmentCode:String = runFagalMethod(F_Segment);

			trace("Compiling AGAL Code:");
			trace("--------------------");
			trace(vertexCode);
			trace("--------------------");
			trace(fragmentCode);
		}
	}
}


package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterMatrix;
	import me.feng3d.fagal.methods.FagalMethod;


	/**
	 * 天空盒顶点渲染程序
	 * @author warden_feng 2014-11-4
	 */
	[FagalMethod(methodType = "vertex")]
	public class V_SkyBox extends FagalMethod
	{
		[Register(regName = "position_va_3", regType = "in", description = "顶点坐标数据")]
		public var position:Register;

		[Register(regName = "uv_v", regType = "out", description = "uv变量数据")]
		public var uv_v:Register;

		[Register(regName = "projection_vc_matrix", regType = "uniform", description = "顶点程序投影矩阵静态数据")]
		public var projection:RegisterMatrix;

		[Register(regName = "op", regType = "out", description = "位置输出寄存器")]
		public var out:Register;

		override public function runFunc():void
		{
			m44(out, position, projection);
			mov(uv_v, position);
		}
	}
}

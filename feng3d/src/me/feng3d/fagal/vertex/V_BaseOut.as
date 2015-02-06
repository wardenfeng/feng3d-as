package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterMatrix;
	import me.feng3d.fagal.methods.FagalVertexMethod;

	/**
	 * 基本顶点投影渲染
	 * @author warden_feng 2014-10-30
	 */
	public class V_BaseOut extends FagalVertexMethod
	{
		[Register(regName = "animatedPosition_vt_4", regType = "in", description = "动画后的顶点坐标数据")]
		public var animatedPosition:Register;

		[Register(regName = "projection_vc_matrix", regType = "uniform", description = "顶点程序投影矩阵静态数据")]
		public var projection:RegisterMatrix;

		[Register(regName = "op", regType = "out", description = "位置输出寄存器")]
		public var out:Register;

		override public function runFunc():void
		{
			m44(out, animatedPosition, projection);
		}
	}
}

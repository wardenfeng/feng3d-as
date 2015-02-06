package me.feng3d.fagal.vertex.animation
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalVertexMethod;


	/**
	 * 顶点动画渲染程序(CPU)
	 * @author warden_feng 2014-11-3
	 */
	public class V_VertexAnimationCPU extends FagalVertexMethod
	{
		[Register(regName = "position_va_3", regType = "in", description = "顶点坐标数据")]
		public var position:Register;

		[Register(regName = "animatedPosition_vt_4", regType = "out", description = "动画后的顶点坐标数据")]
		public var animatedPosition:Register;

		override public function runFunc():void
		{
			mov(animatedPosition, position);
		}
	}
}

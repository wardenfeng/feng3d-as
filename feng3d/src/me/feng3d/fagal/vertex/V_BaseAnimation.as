package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 基础动画顶点渲染函数(无动画)
	 * @author warden_feng 2014-11-3
	 */
	[FagalMethod(methodType = "vertex")]
	public class V_BaseAnimation extends FagalMethod
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

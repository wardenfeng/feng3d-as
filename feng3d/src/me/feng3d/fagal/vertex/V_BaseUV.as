package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 基本uv渲染程序
	 * @author warden_feng 2014-10-30
	 */
	[FagalMethod(methodType = "vertex")]
	public class V_BaseUV extends FagalMethod
	{
		[Register(regName = "uv_va_2", regType = "in", description = "uv数据")]
		public var uv:Register;

		[Register(regName = "uv_v", regType = "out", description = "uv变量数据")]
		public var uv_v:Register;

		override public function runFunc():void
		{
			mov(uv_v, uv);
		}
	}
}

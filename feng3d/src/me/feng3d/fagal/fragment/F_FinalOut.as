package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 最终颜色输出函数
	 * @author warden_feng 2014-11-7
	 */
	[FagalMethod(methodType = "fragment")]
	public class F_FinalOut extends FagalMethod
	{
		[Register(regName = "finalColor_ft_4", regType = "in", description = "最终颜色寄存器（输出到oc寄存器的颜色）")]
		public var finalColorReg:Register;

		[Register(regName = "oc", regType = "out", description = "颜色输出寄存器")]
		public var out:Register;

		override public function runFunc():void
		{
			mov(out, finalColorReg);
			
			removeTemp(finalColorReg);
		}

	}
}

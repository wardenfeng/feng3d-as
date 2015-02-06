package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalFragmentMethod;

	/**
	 * 编译切线片段程序(无法线图)
	 * @author warden_feng 2014-11-7
	 */
	public class F_TangentNormalNoMap extends FagalFragmentMethod
	{
		[Register(regName = "normal_v", regType = "in", description = "法线变量寄存器")]
		public var normalVaryingReg:Register;

		[Register(regName = "normal_ft_4", regType = "out", description = "法线临时片段寄存器")]
		public var normalFragmentReg:Register;

		override public function runFunc():void
		{
			//标准化法线
			nrm(normalFragmentReg.xyz, normalVaryingReg);
			//保存w不变
			mov(normalFragmentReg.w, normalVaryingReg.w);
		}

	}
}

package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalFragmentMethod;

	/**
	 * 视线片段渲染函数
	 * @author warden_feng 2014-11-7
	 */
	public class F_ViewDir extends FagalFragmentMethod
	{
		[Register(regName = "viewDir_v", regType = "in", description = "视线变量寄存器")]
		public var viewDirVaryingReg:Register;

		[Register(regName = "viewDir_ft_4", regType = "out", description = "视线方向片段临时数据")]
		public var viewDirFragmentReg:Register;

		override public function runFunc():void
		{
			//标准化视线
			nrm(viewDirFragmentReg.xyz, viewDirVaryingReg);
			//保持w不变
			mov(viewDirFragmentReg.w, viewDirVaryingReg.w);
		}
	}
}

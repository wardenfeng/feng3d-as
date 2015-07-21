package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.nrm;

	/**
	 * 视线片段渲染函数
	 * @author warden_feng 2014-11-7
	 */
	public function F_ViewDir(viewDirVaryingReg:Register, viewDirFragmentReg:Register):void
	{
		//标准化视线
		nrm(viewDirFragmentReg.xyz, viewDirVaryingReg);
		//保持w不变
		mov(viewDirFragmentReg.w, viewDirVaryingReg.w);
	}
}

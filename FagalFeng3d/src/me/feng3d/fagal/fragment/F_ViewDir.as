package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.nrm;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 视线片段渲染函数
	 * @author warden_feng 2014-11-7
	 */
	public function F_ViewDir():void
	{
		//视线变量寄存器
		var viewDirVaryingReg:Register = requestRegister(Context3DBufferTypeID.viewDir_v);
		//视线方向片段临时数据
		var viewDirFragmentReg:Register = requestRegister(Context3DBufferTypeID.viewDir_ft_4);

		//标准化视线
		nrm(viewDirFragmentReg.xyz, viewDirVaryingReg);
		//保持w不变
		mov(viewDirFragmentReg.w, viewDirVaryingReg.w);
	}
}

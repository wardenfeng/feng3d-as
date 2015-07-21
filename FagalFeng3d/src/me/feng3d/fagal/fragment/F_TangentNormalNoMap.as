package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.nrm;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 编译切线片段程序(无法线图)
	 * @author warden_feng 2014-11-7
	 */
	public function F_TangentNormalNoMap():void
	{
		//法线变量寄存器
		var normalVaryingReg:Register = requestRegister(Context3DBufferTypeID.NORMAL_V);
		//法线临时片段寄存器
		var normalFragmentReg:Register = requestRegister(Context3DBufferTypeID.NORMAL_FT_4);

		//标准化法线
		nrm(normalFragmentReg.xyz, normalVaryingReg);
		//保存w不变
		mov(normalFragmentReg.w, normalVaryingReg.w);

	}
}

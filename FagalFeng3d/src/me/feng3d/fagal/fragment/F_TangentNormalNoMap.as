package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.nrm;

	/**
	 * 编译切线片段程序(无法线图)
	 * @author warden_feng 2014-11-7
	 */
	public function F_TangentNormalNoMap(normalVaryingReg:Register, normalFragmentReg:Register):void
	{
		//标准化法线
		nrm(normalFragmentReg.xyz, normalVaryingReg);
		//保存w不变
		mov(normalFragmentReg.w, normalVaryingReg.w);

	}
}

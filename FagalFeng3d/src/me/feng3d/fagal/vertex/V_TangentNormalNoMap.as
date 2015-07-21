package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.operation.m33;
	import me.feng3d.fagal.base.operation.mov;

	/**
	 * 编译切线顶点程序(无法线图)
	 * @author warden_feng 2014-11-7
	 */
	public function V_TangentNormalNoMap(animatedNormalReg:Register, normalVaryingReg:Register, normalMatrixReg:Register):void
	{
		comment("转换法线到全局");
		m33(normalVaryingReg.xyz, animatedNormalReg, normalMatrixReg);
		//保存w不变
		mov(normalVaryingReg.w, animatedNormalReg.w);
	}

}

package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.m33;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 编译切线顶点程序(无法线图)
	 * @author warden_feng 2014-11-7
	 */
	public function V_TangentNormalNoMap():void
	{
		//法线数据
		var animatedNormalReg:Register = requestRegister(Context3DBufferTypeID.NORMAL_VA_3);
		//法线变量寄存器
		var normalVaryingReg:Register = requestRegister(Context3DBufferTypeID.NORMAL_V);
		//法线场景变换矩阵(模型空间转场景空间)
		var normalMatrixReg:Register = requestRegister(Context3DBufferTypeID.NORMALSCENETRANSFORM_VC_MATRIX);

		comment("转换法线到全局");
		m33(normalVaryingReg.xyz, animatedNormalReg, normalMatrixReg);
		//保存w不变
		mov(normalVaryingReg.w, animatedNormalReg.w);
	}

}

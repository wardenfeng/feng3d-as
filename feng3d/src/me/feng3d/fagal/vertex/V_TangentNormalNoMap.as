package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalMethod;


	/**
	 * 编译切线顶点程序(无法线图)
	 * @author warden_feng 2014-11-7
	 */
	[FagalMethod(methodType = "vertex")]
	public class V_TangentNormalNoMap extends FagalMethod
	{

		[Register(regName = "normal_va_3", regType = "in", description = "法线数据")]
		public var animatedNormalReg:Register;

		[Register(regName = "normal_v", regType = "out", description = "法线变量寄存器")]
		public var normalVaryingReg:Register;

		[Register(regName = "normalglobaltransform_vc_matrix", regType = "uniform", description = "法线全局转换矩阵寄存器")]
		public var normalMatrixReg:Register;

		override public function runFunc():void
		{
			comment("转换法线到全局");
			m33(normalVaryingReg.xyz, animatedNormalReg, normalMatrixReg);
			//保存w不变
			mov(normalVaryingReg.w, animatedNormalReg.w);
		}

	}
}

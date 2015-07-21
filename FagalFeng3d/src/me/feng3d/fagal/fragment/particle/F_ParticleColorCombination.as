package me.feng3d.fagal.fragment.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 *
	 * @author warden_feng 2015-1-21
	 */
	public function F_ParticleColorCombination():void
	{
		//粒子颜色乘数因子，用于乘以纹理上的颜色值
		var colorMulVary:Register = requestRegister(Context3DBufferTypeID.PARTICLECOLORMULTIPLIER_V);
		//粒子颜色偏移值，在片段渲染的最终颜色值上偏移
		var colorAddVary:Register = requestRegister(Context3DBufferTypeID.PARTICLECOLOROFFSET_V);
		//最终颜色寄存器（输出到oc寄存器的颜色）
		var finalColorReg:Register = requestRegister(Context3DBufferTypeID.FINALCOLOR_FT_4);

//			if (hasColorMulNode)
		mul(finalColorReg, finalColorReg, colorMulVary);
//			if (hasColorAddNode)
		add(finalColorReg, finalColorReg, colorAddVary);
	}
}

package me.feng3d.fagal.fragment.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.context3dDataIds.ParticleContext3DBufferID;
	import me.feng3d.fagal.methods.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsParticle;

	/**
	 * 粒子片段渲染程序
	 * @author warden_feng 2015-1-21
	 */
	public function F_Particles():void
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		/** 粒子渲染参数 */
		var particleShaderParam:ShaderParamsParticle = shaderParams.getComponent(ShaderParamsParticle.NAME);
		if (particleShaderParam.ParticleColorGlobal)
		{
			//粒子颜色乘数因子，用于乘以纹理上的颜色值
			var colorMulVary:Register = requestRegister(ParticleContext3DBufferID.PARTICLECOLORMULTIPLIER_V);
			//粒子颜色偏移值，在片段渲染的最终颜色值上偏移
			var colorAddVary:Register = requestRegister(ParticleContext3DBufferID.PARTICLECOLOROFFSET_V);
			//最终颜色寄存器（输出到oc寄存器的颜色）
			var finalColorReg:Register = requestRegister(Context3DBufferTypeID.FINALCOLOR_FT_4);

			F_ParticleColorCombination(colorMulVary, colorAddVary, finalColorReg);
		}

	}
}

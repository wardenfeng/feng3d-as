package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.operation.mov;

	/**
	 * 粒子颜色初始化
	 * @param particleCommon		粒子常数数据[0,1,2,0]
	 * @param colorMulTarget		粒子颜色乘数因子，用于乘以纹理上的颜色值
	 * @param colorAddTarget		粒子颜色偏移值，在片段渲染的最终颜色值上偏移
	 * @author warden_feng 2015-1-20
	 */
	public function V_ParticlesInitColor(particleCommon:Register, colorMulTarget:Register, colorAddTarget:Register):void
	{
		//初始化  粒子颜色乘数因子 为(1,1,1,1)
		mov(colorMulTarget, particleCommon.y);
		//初始化 粒子颜色偏移值 为(0,0,0,0)
		mov(colorAddTarget, particleCommon.x);
	}
}

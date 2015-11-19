package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 粒子颜色变化结算顶点渲染程序
	 * @param colorMulTarget			粒子颜色乘数因子，用于乘以纹理上的颜色值
	 * @param colorAddTarget			粒子颜色偏移值，在片段渲染的最终颜色值上偏移
	 * @param colorMulVary				粒子颜色乘数因子，用于乘以纹理上的颜色值
	 * @param colorAddVary				粒子颜色偏移值，在片段渲染的最终颜色值上偏移
	 * @author feng 2015-1-20
	 */
	public function V_ParticleColorEnd(colorMulTarget:Register, colorAddTarget:Register, colorMulVary:Register, colorAddVary:Register):void
	{
		var _:* = FagalRE.instance.space;

//			if (hasColorMulNode)
		_.mov(colorMulVary, colorMulTarget);
//			if (hasColorAddNode)
		_.mov(colorAddVary, colorAddTarget);
	}
}

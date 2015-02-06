package me.feng3d.fagal.fragment.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalFragmentMethod;


	/**
	 *
	 * @author warden_feng 2015-1-21
	 */
	public class F_ParticleColorCombination extends FagalFragmentMethod
	{
		[Register(regName = "particleColorMultiplier_v", regType = "in", description = "粒子颜色乘数因子，用于乘以纹理上的颜色值")]
		public var colorMulVary:Register;

		[Register(regName = "particleColorOffset_v", regType = "in", description = "粒子颜色偏移值，在片段渲染的最终颜色值上偏移")]
		public var colorAddVary:Register;
		
		[Register(regName = "finalColor_ft_4", regType = "in", description = "最终颜色寄存器（输出到oc寄存器的颜色）")]
		public var finalColorReg:Register;

		override public function runFunc():void
		{
//			if (hasColorMulNode)
			mul(finalColorReg, finalColorReg, colorMulVary);
//			if (hasColorAddNode)
			add(finalColorReg, finalColorReg, colorAddVary);
		}
	}
}

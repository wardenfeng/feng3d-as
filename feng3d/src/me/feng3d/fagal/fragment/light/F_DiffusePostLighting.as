package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.fragment.F_DiffuseColor;
	import me.feng3d.fagal.fragment.F_DiffuseTexure;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 发布漫反射光
	 * @author warden_feng 2014-11-7
	 */
	[FagalMethod(methodType = "fragment")]
	public class F_DiffusePostLighting extends FagalMethod
	{
		[Register(regName = "totalDiffuseLightColor_ft_4", regType = "in", description = "总漫反射颜色寄存器")]
		public var totalLightColorReg:Register;

		[Register(regName = "finalColor_ft_4", regType = "out", description = "最终颜色寄存器（输出到oc寄存器的颜色）")]
		public var finalColorReg:Register;

		[Register(regName = "Mdiff_ft", regType = "out", description = "材质的漫反射颜色")]
		public var mdiffReg:Register;

		override public function runFunc():void
		{
			//获取漫反射灯光
			if (shaderParams.hasDiffuseTexture)
			{
				call(F_DiffuseTexure);
			}
			else
			{
				call(F_DiffuseColor);
			}

			if (shaderParams.numLights == 0)
			{
				mov(finalColorReg, mdiffReg);
				return;
			}

			//控制在0到1之间
			sat(totalLightColorReg, totalLightColorReg);

			//混合漫反射光
			mul(finalColorReg.xyz, mdiffReg, totalLightColorReg);
			//保存w值不变
			mov(finalColorReg.w, mdiffReg.w);
			
			removeTemp(totalLightColorReg);
		}
	}
}

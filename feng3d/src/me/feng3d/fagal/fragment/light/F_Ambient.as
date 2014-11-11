package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 环境光片段渲染程序
	 * @author warden_feng 2014-11-7
	 */
	[FagalMethod(methodType="fragment")]
	public class F_Ambient extends FagalMethod
	{
		[Register(regName = "ambientInput_fc_vector", regType = "uniform", description = "环境输入静态数据")]
		public var ambientInputReg:Register;

		[Register(regName = "finalColor_ft_4", regType = "in", description = "最终颜色寄存器（输出到oc寄存器的颜色）")]
		public var finalColorReg:Register;

		[Register(regName = "Mdiff_ft", regType = "in", description = "材质的漫反射颜色")]
		public var mdiffReg:Register;

		override public function runFunc():void
		{
			var blendAmbientReg:Register = getFreeTemp("混合环境光");

			//混合漫反射光
			mul(blendAmbientReg, mdiffReg, ambientInputReg);
			//添加到最终颜色
			add(finalColorReg.xyz, finalColorReg, blendAmbientReg);
			
			removeTemp(mdiffReg);
		}

	}
}

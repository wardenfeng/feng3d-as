package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 发布镜面反射光
	 * @author warden_feng 2014-11-7
	 */
	[FagalMethod(methodType = "fragment")]
	public class F_SpecularPostLighting extends FagalMethod
	{
		[Register(regName = "totalSpecularLightColor_ft_4", regType = "in", description = "总漫反射颜色寄存器")]
		public var totalSpecularColorReg:Register;

		[Register(regName = "finalColor_ft_4", regType = "in", description = "最终颜色寄存器（输出到oc寄存器的颜色）")]
		public var finalColorReg:Register;

		[Register(regName = "textureSpecular_fc_vector", regType = "uniform", description = "材质镜面反射光数据")]
		public var _specularDataRegister:Register;

		override public function runFunc():void
		{
			//混合镜面反射光 = 镜面反射光颜色 mul 材质镜面反射颜色
			mul(totalSpecularColorReg, totalSpecularColorReg, _specularDataRegister);
			//添加到最终颜色中
			add(finalColorReg.xyz, finalColorReg, totalSpecularColorReg);
			
			removeTemp(totalSpecularColorReg);
		}
	}
}

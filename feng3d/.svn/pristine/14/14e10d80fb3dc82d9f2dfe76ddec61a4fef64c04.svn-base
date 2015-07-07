package me.feng3d.fagal.base
{
	import flash.display3D.Context3DProgramType;
	
	import me.feng3d.arcanefagal;
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalRE;

	use namespace arcanefagal;
	
	/**
	 * 获取临时寄存器
	 * @param description 寄存器描述
	 * @return
	 * @author warden_feng 2015-4-24
	 */
	public function getFreeTemp(description:String = ""):Register
	{
		var register:Register;
		if (FagalRE.instance.shaderType == Context3DProgramType.VERTEX)
		{
			register = FagalRE.instance.regCache.getFreeVertexTemp();
		}
		else
		{
			register = FagalRE.instance.regCache.getFreeFragmentTemp();
		}
		register.description = description;

		comment(register + ":" + register.description);
		return register;
	}
}

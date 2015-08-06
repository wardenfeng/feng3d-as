package me.feng3d.fagal.base
{
	import me.feng3d.arcanefagal;
	import me.feng3d.core.register.Register;
	import me.feng3d.fagalRE.FagalRegisterCenter;

	use namespace arcanefagal;

	/**
	 * 获取临时寄存器
	 * @param description 寄存器描述
	 * @return
	 * @author warden_feng 2015-4-24
	 */
	public function getFreeTemp(description:String = ""):Register
	{
		var register:Register = FagalRegisterCenter.getFreeTemp(description);
		return register;
	}
}

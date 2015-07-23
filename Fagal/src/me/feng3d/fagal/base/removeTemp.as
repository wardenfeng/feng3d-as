package me.feng3d.fagal.base
{
	import me.feng3d.arcanefagal;
	import me.feng3d.core.register.Register;
	import me.feng3d.fagalRE.FagalRE;

	use namespace arcanefagal;

	/**
	 * 移除不用了的寄存器
	 * @param register 寄存器
	 * @author warden_feng 2015-4-24
	 */
	public function removeTemp(register:Register):void
	{
		FagalRE.instance.regCache.removeTempUsage(register);
	}
}

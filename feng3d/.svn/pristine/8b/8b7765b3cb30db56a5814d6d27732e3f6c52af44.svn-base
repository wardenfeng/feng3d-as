package me.feng3d.fagal.base
{
	import me.feng3d.arcanefagal;
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalRE;

	use namespace arcanefagal;

	/**
	 * 申请数据寄存器
	 * @param dataType 数据类型
	 * @param numRegister 寄存器的个数(默认1个)
	 * @return 数据寄存器
	 * @author warden_feng 2015-4-24
	 */
	public function requestRegister(dataTypeId:String, numRegister:int = 1):Register
	{
		var register:Register = FagalRE.instance.regCache.requestRegister(dataTypeId, numRegister);
		return register;
	}
}

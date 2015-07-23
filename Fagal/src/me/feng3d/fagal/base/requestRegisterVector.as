package me.feng3d.fagal.base
{
	import me.feng3d.arcanefagal;
	import me.feng3d.core.register.RegisterVector;
	import me.feng3d.fagalRE.FagalRE;

	use namespace arcanefagal;
	
	/**
	 * 申请数据寄存器向量
	 * @param dataType 数据类型
	 * @param numRegister 寄存器的个数(默认1个)
	 * @return 数据寄存器
	 * @author warden_feng 2015-4-24
	 */
	public function requestRegisterVector(dataTypeId:String, numRegister:int):RegisterVector
	{
		var register:RegisterVector = FagalRE.instance.regCache.requestRegisterVector(dataTypeId, numRegister);
		return register;
	}
}

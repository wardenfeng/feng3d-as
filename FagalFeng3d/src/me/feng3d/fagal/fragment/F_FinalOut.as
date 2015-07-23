package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 最终颜色输出函数
	 * @author warden_feng 2014-11-7
	 */
	public function F_FinalOut():void
	{
		//最终颜色寄存器（输出到oc寄存器的颜色）
		var finalColorReg:Register = requestRegister(Context3DBufferTypeID.finalColor_ft_4);
		//颜色输出寄存器
		var out:Register = requestRegister(Context3DBufferTypeID._oc);

		mov(out, finalColorReg);

		removeTemp(finalColorReg);
	}
}

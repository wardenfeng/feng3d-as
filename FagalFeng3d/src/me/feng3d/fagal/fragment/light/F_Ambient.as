package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 环境光片段渲染程序
	 * @author warden_feng 2014-11-7
	 */
	public function F_Ambient():void
	{
		//环境输入静态数据
		var ambientInputReg:Register = requestRegister(Context3DBufferTypeID.AMBIENTINPUT_FC_VECTOR);
		var ambientTempReg:Register = requestRegister(Context3DBufferTypeID.AMBIENT_FT);

		mov(ambientTempReg, ambientInputReg);
	}
}

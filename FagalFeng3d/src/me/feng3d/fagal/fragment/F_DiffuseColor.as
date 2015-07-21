package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 漫反射材质颜色
	 * @author warden_feng 2014-11-6
	 */
	public function F_DiffuseColor():void
	{
		//漫射输入静态数据
		var diffColorReg:Register = requestRegister(Context3DBufferTypeID.DIFFUSEINPUT_FC_VECTOR);
		//材质的漫反射颜色
		var mdiffReg:Register = requestRegister(Context3DBufferTypeID.MDIFF_FT);

		//漫射输入静态数据 
		mov(mdiffReg, diffColorReg);
	}
}

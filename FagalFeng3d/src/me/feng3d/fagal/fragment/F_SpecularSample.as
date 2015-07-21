package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.tex;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 光泽图取样函数
	 * @author warden_feng 2014-10-23
	 */
	public function F_SpecularSample():void
	{
		//光泽纹理寄存器
		var specularFragmentReg:Register = requestRegister(Context3DBufferTypeID.SPECULARTEXTURE_FS);
		//uv变量数据
		var uv:Register = requestRegister(Context3DBufferTypeID.UV_V);
		//光泽纹理数据片段临时寄存器
		var specularTexData:Register = requestRegister(Context3DBufferTypeID.SPECULARTEXDATA_FT_4);

		//获取纹理数据
		tex(specularTexData, uv, specularFragmentReg);
	}
}

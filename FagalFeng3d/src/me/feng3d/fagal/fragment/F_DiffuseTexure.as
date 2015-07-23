package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.tex;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 漫反射纹理取样
	 * @author warden_feng 2014-11-6
	 */
	public function F_DiffuseTexure():void
	{
		//片段程序的纹理
		var diffuseTexReg:Register = requestRegister(Context3DBufferTypeID.texture_fs);
		//uv变量数据
		var uvReg:Register = requestRegister(Context3DBufferTypeID.uv_v);
		//材质的漫反射颜色
		var mdiffReg:Register = requestRegister(Context3DBufferTypeID.mDiff_ft);

		tex(mdiffReg, uvReg, diffuseTexReg);
	}
}

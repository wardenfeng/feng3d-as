package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.nrm;
	import me.feng3d.fagal.base.operation.sub;
	import me.feng3d.fagal.base.operation.tex;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 法线取样函数
	 * @author warden_feng 2014-10-23
	 */
	public function F_NormalSample():void
	{
		//法线纹理数据片段临时寄存器
		var normalTexData:Register = requestRegister(Context3DBufferTypeID.NORMALTEXDATA_FT_4);
		//法线纹理寄存器
		var normalTexture:Register = requestRegister(Context3DBufferTypeID.NORMALTEXTURE_FS);
		//uv变量数据
		var uv:Register = requestRegister(Context3DBufferTypeID.UV_V);
		//公用数据片段常量数据
		var commonsData:Register = requestRegister(Context3DBufferTypeID.COMMONSDATA_FC_VECTOR);

		//获取纹理数据
		tex(normalTexData, uv, normalTexture);
		//使法线纹理数据 【0,1】->【-0.5,0.5】
		sub(normalTexData.xyz, normalTexData.xyz, commonsData.xxx);

		//标准化法线纹理数据
		nrm(normalTexData.xyz, normalTexData.xyz);
	}
}

package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.m33;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.nrm;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDCommon;

	/**
	 * 编译切线法线贴图片段程序
	 * @author warden_feng 2014-11-7
	 */
	public function F_TangentNormalMap(tangentVarying:Register, bitangentVarying:Register, normalVarying:Register, normalTexData:Register, normalFragment:Register):void
	{
		//t、b、n 法线所在顶点的变换矩阵
		var t:Register = getFreeTemp("切线片段临时寄存器");
		var b:Register = getFreeTemp("双切线片段临时寄存器");
		var n:Register = getFreeTemp("法线片段临时寄存器");

		//标准化切线
		nrm(t.xyz, tangentVarying);
		//保存w不变
		mov(t.w, tangentVarying.w);
		//标准化双切线
		nrm(b.xyz, bitangentVarying);
		//标准化法线
		nrm(n.xyz, normalVarying);

		//法线纹理寄存器
		var normalTexture:Register = requestRegister(Context3DBufferTypeID.NORMALTEXTURE_FS);
		//uv变量数据
		var uv:Register = requestRegister(Context3DBufferTypeIDCommon.UV_V);
		//公用数据片段常量数据
		var commonsData:Register = requestRegister(Context3DBufferTypeIDCommon.COMMONSDATA_FC_VECTOR);

		F_NormalSample(normalTexture, uv, normalTexData, commonsData);

		//标准化法线纹理数据
		m33(normalFragment.xyz, normalTexData, t);
//			mov(normalFragment.xyz, normalTexData);
		//保存w不变
		mov(normalFragment.w, normalVarying.w);

		removeTemp(normalTexData);
		removeTemp(t);
		removeTemp(b);
		removeTemp(n);

	}
}

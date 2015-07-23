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

	/**
	 * 编译切线法线贴图片段程序
	 * @author warden_feng 2014-11-7
	 */
	public function F_TangentNormalMap():void
	{
		//切线变量寄存器
		var tangentVarying:Register = requestRegister(Context3DBufferTypeID.tangent_v);
		//双切线变量寄存器
		var bitangentVarying:Register = requestRegister(Context3DBufferTypeID.bitangent_v);
		//法线变量寄存器
		var normalVarying:Register = requestRegister(Context3DBufferTypeID.normal_v);
		//法线纹理数据片段临时寄存器
		var normalTexData:Register = requestRegister(Context3DBufferTypeID.normalTexData_ft_4);

		//法线临时片段寄存器
		var normalFragment:Register = requestRegister(Context3DBufferTypeID.normal_ft_4);

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

		F_NormalSample();

		//标准化法线纹理数据
		m33(normalFragment.xyz, normalTexData, t);
		//保存w不变
		mov(normalFragment.w, normalVarying.w);

		removeTemp(normalTexData);
		removeTemp(t);
		removeTemp(b);
		removeTemp(n);

	}
}

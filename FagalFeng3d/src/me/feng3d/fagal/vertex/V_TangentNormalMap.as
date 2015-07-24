package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.operation.crs;
	import me.feng3d.fagal.base.operation.m33;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.nrm;
	import me.feng3d.fagalRE.FagalRE;


	/**
	 * 编译切线顶点程序
	 * @author warden_feng 2014-11-7
	 */
	public function V_TangentNormalMap():void
	{
		var _:* = FagalRE.instance.space;

		var animatedNormal:Register = getFreeTemp("动画后顶点法线临时寄存器");
		var animatedTangent:Register = getFreeTemp("动画后顶点切线临时寄存器");
		var bitanTemp:Register = getFreeTemp("动画后顶点双切线临时寄存器");

		//赋值法线数据
		mov(animatedNormal, _.normal_va_3);
		//赋值切线数据
		mov(animatedTangent, _.tangent_va_3);

		//计算顶点世界法线 vc8：模型转世界矩阵
		m33(animatedNormal.xyz, animatedNormal, _.normalSceneTransform_vc_matrix);
		//标准化顶点世界法线
		nrm(animatedNormal.xyz, animatedNormal);

		//计算顶点世界切线
		m33(animatedTangent.xyz, animatedTangent, _.normalSceneTransform_vc_matrix);
		//标准化顶点世界切线
		nrm(animatedTangent.xyz, animatedTangent);

		//计算切线x
		mov(_.tangent_v.x, animatedTangent.x);
		//计算切线z
		mov(_.tangent_v.z, animatedNormal.x);
		//计算切线w
		mov(_.tangent_v.w, _.normal_va_3.w);
		//计算双切线x
		mov(_.bitangent_v.x, animatedTangent.y);
		//计算双切线z
		mov(_.bitangent_v.z, animatedNormal.y);
		//计算双切线w
		mov(_.bitangent_v.w, _.normal_va_3.w);
		//计算法线x
		mov(_.normal_v.x, animatedTangent.z);
		//计算法线z
		mov(_.normal_v.z, animatedNormal.z);
		//计算法线w
		mov(_.normal_v.w, _.normal_va_3.w);
		//计算双切线
		crs(bitanTemp.xyz, animatedNormal, animatedTangent);
		//计算切线y
		mov(_.tangent_v.y, bitanTemp.x);
		//计算双切线y
		mov(_.bitangent_v.y, bitanTemp.y);
		//计算法线y
		mov(_.normal_v.y, bitanTemp.z);

		removeTemp(animatedNormal);
		removeTemp(animatedTangent);
		removeTemp(bitanTemp);
	}

}

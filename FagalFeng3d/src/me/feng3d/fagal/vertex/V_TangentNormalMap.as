package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterArray;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 编译切线顶点程序
	 * @author feng 2014-11-7
	 */
	public function V_TangentNormalMap():void
	{
		var _:* = FagalRE.instance.space;

		var animatedNormal:Register = _.getFreeTemp("动画后顶点法线临时寄存器");
		var animatedTangent:Register = _.getFreeTemp("动画后顶点切线临时寄存器");
		var bitanTemp:Register = _.getFreeTemp("动画后顶点双切线临时寄存器");

		//赋值法线数据
		_.mov(animatedNormal, _.normal_va_3);
		//赋值切线数据
		_.mov(animatedTangent, _.tangent_va_3);

		//计算顶点世界法线 vc8：模型转世界矩阵
		_.m33(animatedNormal.xyz, animatedNormal, _.normalSceneTransform_vc_matrix);
		//标准化顶点世界法线
		_.nrm(animatedNormal.xyz, animatedNormal);

		//计算顶点世界切线
		_.m33(animatedTangent.xyz, animatedTangent, _.normalSceneTransform_vc_matrix);
		//标准化顶点世界切线
		_.nrm(animatedTangent.xyz, animatedTangent);

		//计算切线x
		_.mov(_.tangent_v.x, animatedTangent.x);
		//计算切线z
		_.mov(_.tangent_v.z, animatedNormal.x);
		//计算切线w
		_.mov(_.tangent_v.w, _.normal_va_3.w);
		//计算双切线x
		_.mov(_.bitangent_v.x, animatedTangent.y);
		//计算双切线z
		_.mov(_.bitangent_v.z, animatedNormal.y);
		//计算双切线w
		_.mov(_.bitangent_v.w, _.normal_va_3.w);
		//计算法线x
		_.mov(_.normal_v.x, animatedTangent.z);
		//计算法线z
		_.mov(_.normal_v.z, animatedNormal.z);
		//计算法线w
		_.mov(_.normal_v.w, _.normal_va_3.w);
		//计算双切线
		_.crs(bitanTemp.xyz, animatedNormal, animatedTangent);
		//计算切线y
		_.mov(_.tangent_v.y, bitanTemp.x);
		//计算双切线y
		_.mov(_.bitangent_v.y, bitanTemp.y);
		//计算法线y
		_.mov(_.normal_v.y, bitanTemp.z);
	}

}

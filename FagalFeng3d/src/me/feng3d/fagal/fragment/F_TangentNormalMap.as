package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 编译切线法线贴图片段程序
	 * @author warden_feng 2014-11-7
	 */
	public function F_TangentNormalMap():void
	{
		var _:* = FagalRE.instance.space;

		//t、b、n 法线所在顶点的变换矩阵
		var t:Register = getFreeTemp("切线片段临时寄存器");
		var b:Register = getFreeTemp("双切线片段临时寄存器");
		var n:Register = getFreeTemp("法线片段临时寄存器");

		//标准化切线
		_.nrm(t.xyz, _.tangent_v);
		//保存w不变
		_.mov(t.w, _.tangent_v.w);
		//标准化双切线
		_.nrm(b.xyz, _.bitangent_v);
		//标准化法线
		_.nrm(n.xyz, _.normal_v);

		F_NormalSample();

		//标准化法线纹理数据
		_.m33(_.normal_ft_4.xyz, _.normalTexData_ft_4, t);
		//保存w不变
		_.mov(_.normal_ft_4.w, _.normal_v.w);
	}
}

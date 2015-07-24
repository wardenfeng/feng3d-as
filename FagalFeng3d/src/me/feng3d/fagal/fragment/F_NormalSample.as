package me.feng3d.fagal.fragment
{
	import me.feng3d.fagal.base.operation.nrm;
	import me.feng3d.fagal.base.operation.sub;
	import me.feng3d.fagal.base.operation.tex;
	import me.feng3d.fagalRE.FagalRE;


	/**
	 * 法线取样函数
	 * @author warden_feng 2014-10-23
	 */
	public function F_NormalSample():void
	{
		var _:* = FagalRE.instance.space;

		//获取纹理数据
		tex(_.normalTexData_ft_4, _.uv_v, _.normalTexture_fs);
		//使法线纹理数据 【0,1】->【-0.5,0.5】
		sub(_.normalTexData_ft_4.xyz, _.normalTexData_ft_4.xyz, _.commonsData_fc_vector.xxx);

		//标准化法线纹理数据
		nrm(_.normalTexData_ft_4.xyz, _.normalTexData_ft_4.xyz);
	}
}

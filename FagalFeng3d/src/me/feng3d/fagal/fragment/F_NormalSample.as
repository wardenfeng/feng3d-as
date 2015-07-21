package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.operation.nrm;
	import me.feng3d.fagal.base.operation.sub;
	import me.feng3d.fagal.base.operation.tex;

	/**
	 * 法线取样函数
	 * @author warden_feng 2014-10-23
	 */
	public function F_NormalSample(normalTexture:Register, uv:Register, normalTexData:Register, commonsData:Register):void
	{
		//获取纹理数据
		tex(normalTexData, uv, normalTexture);
		//使法线纹理数据 【0,1】->【-0.5,0.5】
		sub(normalTexData.xyz, normalTexData.xyz, commonsData.xxx);

		//标准化法线纹理数据
		nrm(normalTexData.xyz, normalTexData.xyz);
	}
}

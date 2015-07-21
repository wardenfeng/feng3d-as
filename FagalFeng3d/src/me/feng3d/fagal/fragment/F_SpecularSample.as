package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.operation.tex;

	/**
	 * 光泽图取样函数
	 * @author warden_feng 2014-10-23
	 */
	public function F_SpecularSample(specularFragmentReg:Register, uv:Register, specularTexData:Register):void
	{
		//获取纹理数据
		tex(specularTexData, uv, specularFragmentReg);
	}
}

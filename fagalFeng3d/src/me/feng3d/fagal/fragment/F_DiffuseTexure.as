package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.params.CommonShaderParams;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 漫反射纹理取样
	 * @author feng 2014-11-6
	 */
	public function F_DiffuseTexure():void
	{
		var _:* = FagalRE.instance.space;
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var commonShaderParams:CommonShaderParams = shaderParams.getComponent(CommonShaderParams.NAME);

		_.tex(_.mDiff_ft, _.uv_v, _.texture_fs);

		if (commonShaderParams.alphaThreshold > 0)
		{
			var cutOffReg:Register = _.alphaThreshold_fc_vector;
			_.sub(_.mDiff_ft.w, _.mDiff_ft.w, cutOffReg.x);
			_.kil(_.mDiff_ft.w);
			_.add(_.mDiff_ft.w, _.mDiff_ft.w, cutOffReg.x);
		}
	}
}

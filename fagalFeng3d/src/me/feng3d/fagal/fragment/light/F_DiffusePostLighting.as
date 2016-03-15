package me.feng3d.fagal.fragment.light
{
	import me.feng3d.fagal.fragment.F_DiffuseColor;
	import me.feng3d.fagal.fragment.F_DiffuseTexure;
	import me.feng3d.fagal.params.CommonShaderParams;
	import me.feng3d.fagal.params.LightShaderParams;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShadowShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 发布漫反射光
	 * @author feng 2014-11-7
	 */
	public function F_DiffusePostLighting():void
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var commonShaderParams:CommonShaderParams = shaderParams.getOrCreateComponentByClass(CommonShaderParams);
		var lightShaderParams:LightShaderParams = shaderParams.getOrCreateComponentByClass(LightShaderParams);
		var shadowShaderParams:ShadowShaderParams = shaderParams.getOrCreateComponentByClass(ShadowShaderParams);


		var _:* = FagalRE.instance.space;

		//把阴影使用到漫反射光上
		if (lightShaderParams.numLights > 0 && shadowShaderParams.needsShadowRegister > 0)
		{
			_.mul(_.totalDiffuseLightColor_ft_4.xyz, _.totalDiffuseLightColor_ft_4, _.shadowValue_ft_4.w);
		}

		//获取漫反射灯光
		if (commonShaderParams.hasDiffuseTexture > 0)
		{
			F_DiffuseTexure();
		}
		else
		{
			F_DiffuseColor();
		}

		if (lightShaderParams.numLights == 0)
		{
			_.mov(_.finalColor_ft_4, _.mDiff_ft);
			return;
		}

		//控制在0到1之间
		_.sat(_.totalDiffuseLightColor_ft_4, _.totalDiffuseLightColor_ft_4);

		if (commonShaderParams.useAmbientTexture > 0)
		{
			_.mul(_.mDiff_ft.xyz, _.mDiff_ft, _.totalDiffuseLightColor_ft_4); //
			_.mul(_.totalDiffuseLightColor_ft_4.xyz, _.finalColor_ft_4, _.totalDiffuseLightColor_ft_4); //
			_.sub(_.finalColor_ft_4.xyz, _.finalColor_ft_4, _.totalDiffuseLightColor_ft_4); //
			_.add(_.finalColor_ft_4.xyz, _.mDiff_ft, _.finalColor_ft_4);
		}
		else
		{
			//漫反射 + 环境光 因子
			_.add(_.finalColor_ft_4.xyz, _.totalDiffuseLightColor_ft_4, _.finalColor_ft_4);

			//混合漫反射光
			_.mul(_.finalColor_ft_4.xyz, _.mDiff_ft, _.finalColor_ft_4);
			//保存w值不变
			_.mov(_.finalColor_ft_4.w, _.mDiff_ft.w);
		}

	}
}



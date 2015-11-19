package me.feng3d.fagal.fragment.light
{
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 结算镜面反射光
	 * @author feng 2014-11-7
	 */
	public function F_SpecularPostLighting():void
	{
		var _:* = FagalRE.instance.space;
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;

		//把阴影值使用到镜面反射上
		if (shaderParams.needsShadowRegister)
		{
			_.mul(_.totalSpecularLightColor_ft_4.xyz, _.totalSpecularLightColor_ft_4, _.shadowValue_ft_4.w);
		}

		if (shaderParams.hasSpecularTexture > 0)
		{
			_.mul(_.totalSpecularLightColor_ft_4.xyz, _.totalSpecularLightColor_ft_4, _.specularTexData_ft_4.x);
		}

		//混合镜面反射光 = 镜面反射光颜色 mul 材质镜面反射颜色
		_.mul(_.totalSpecularLightColor_ft_4.xyz, _.totalSpecularLightColor_ft_4, _.specularData_fc_vector);
		//添加到最终颜色中
		_.add(_.finalColor_ft_4.xyz, _.finalColor_ft_4, _.totalSpecularLightColor_ft_4);

	}
}

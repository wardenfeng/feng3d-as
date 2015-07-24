package me.feng3d.fagal.fragment.light
{
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 结算镜面反射光
	 * @author warden_feng 2014-11-7
	 */
	public function F_SpecularPostLighting():void
	{
		var _:* = FagalRE.instance.space;
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;

		//把阴影值使用到镜面反射上
		if (shaderParams.needsShadowRegister)
		{
			mul(_.totalSpecularLightColor_ft_4.xyz, _.totalSpecularLightColor_ft_4, _.shadowValue_ft_4.w);
		}

		if (shaderParams.hasSpecularTexture)
		{
			mul(_.totalSpecularLightColor_ft_4.xyz, _.totalSpecularLightColor_ft_4, _.specularTexData_ft_4.x);
		}

		//混合镜面反射光 = 镜面反射光颜色 mul 材质镜面反射颜色
		mul(_.totalSpecularLightColor_ft_4.xyz, _.totalSpecularLightColor_ft_4, _.specularData_fc_vector);
		//添加到最终颜色中
		add(_.finalColor_ft_4.xyz, _.finalColor_ft_4, _.totalSpecularLightColor_ft_4);

		removeTemp(_.totalSpecularLightColor_ft_4);
	}
}

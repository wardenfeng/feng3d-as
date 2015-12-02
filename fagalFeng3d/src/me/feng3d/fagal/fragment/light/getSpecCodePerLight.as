package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.params.LightShaderParams;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 计算单个镜面反射光
	 * @author feng 2015-4-24
	 */
	public function getSpecCodePerLight(lightDirReg:Register, specularColorReg:Register):void
	{
		var _:* = FagalRE.instance.space;
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var lightShaderParams:LightShaderParams = shaderParams.getComponentByClass(LightShaderParams);

		//镜面反射光原理
		//法线 = 入射光方向 - 反射光方向------------1
		//物理光学已知：当视线方向与反射光方向相反时，反射光达到最亮。反射光强度和（反射光方向与-视线方向 的 夹角余弦值）相关
		//反射光方向与-视线 的 夹角 ---(代入1)--> (入射光方向 - 法线) 与 -视线 的 夹角 ----> 入射光方向+视线 与 法线的夹角
		//反射光方向与-视线方向 的 夹角余弦值 == 入射光方向+视线 与 法线 的 夹角余弦值  == 反射光强度

		var singleSpecularColorReg:Register;
		if (lightShaderParams.isFirstSpecLight)
		{
			singleSpecularColorReg = _.totalSpecularLightColor_ft_4;
		}
		else
		{
			singleSpecularColorReg = _.getFreeTemp("单个镜面反射光寄存器");
		}

		//灯光模型
		if (shaderParams.specularModelType == SpecularModelType.PHONG)
		{
			F_Phong(singleSpecularColorReg, lightDirReg);
		}
		else
		{
			F_Blinn_Phong(singleSpecularColorReg, lightDirReg);
		}

		if (lightShaderParams.hasSpecularTexture > 0)
		{
			//使用光照图调整高光
			//光泽纹理数据片段临时寄存器
			_.mul(_.specularTexData_ft_4.w, _.specularTexData_ft_4.y, _.specularData_fc_vector.w);
			_.pow(singleSpecularColorReg.w, singleSpecularColorReg.w, _.specularTexData_ft_4.w);
		}
		else
		{
			//镜面反射光强度 = 镜面反射光强度 pow 光泽度
			_.pow(singleSpecularColorReg.w, singleSpecularColorReg.w, _.specularData_fc_vector.w);
		}

		if (lightShaderParams.useLightFallOff)
		{
			//镜面反射光强度 = 镜面反射强度  nul (入射光强度？)
			_.mul(singleSpecularColorReg.w, singleSpecularColorReg.w, lightDirReg.w);
		}

		if (shaderParams.modulateMethod != null)
		{
			shaderParams.modulateMethod(singleSpecularColorReg);
		}

		_.comment("镜面反射光颜色 = 灯光镜面反射颜色 mul 镜面反射光强度");
		_.mul(singleSpecularColorReg.xyz, specularColorReg, singleSpecularColorReg.w);

		//叠加镜面反射光
		if (!lightShaderParams.isFirstSpecLight)
		{
			//总镜面反射光 = 总镜面反射光 + 单个镜面反射光
			_.add(_.totalSpecularLightColor_ft_4.xyz, _.totalSpecularLightColor_ft_4, singleSpecularColorReg);
		}
		lightShaderParams.isFirstSpecLight = false;
	}
}

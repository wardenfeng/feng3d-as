package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.params.LightShaderParams;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 处理
	 * @author feng 2015-4-24
	 */
	public function getDiffCodePerLight(lightDirReg:Register, diffuseColorReg:Register):void
	{
		var _:* = FagalRE.instance.space;

		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var lightShaderParams:LightShaderParams = shaderParams.getComponent(LightShaderParams.NAME);

		var diffuseColorFtReg:Register;
		if (lightShaderParams.isFirstDiffLight)
		{
			diffuseColorFtReg = _.totalDiffuseLightColor_ft_4;
		}
		else
		{
			diffuseColorFtReg = _.getFreeTemp("单个漫反射光寄存器")
		}

		//计算灯光方向与法线夹角
		_.dp3(diffuseColorFtReg.x, lightDirReg, _.normal_ft_4);
		//过滤负数
		_.max(diffuseColorFtReg.w, diffuseColorFtReg.x, _.commonsData_fc_vector.y);

		//灯光衰减
		if (lightShaderParams.useLightFallOff)
			_.mul(diffuseColorFtReg.w, diffuseColorFtReg.w, lightDirReg.w);

		if (shaderParams.diffuseModulateMethod != null)
		{
			shaderParams.diffuseModulateMethod(diffuseColorFtReg);
		}

		_.comment("漫反射光颜色 = 灯光漫反射颜色 mul 漫反射光强度");
		_.mul(diffuseColorFtReg, diffuseColorFtReg.w, diffuseColorReg);

		//叠加灯光
		if (!lightShaderParams.isFirstDiffLight)
		{
			_.add(_.totalDiffuseLightColor_ft_4.xyz, _.totalDiffuseLightColor_ft_4, diffuseColorFtReg);
		}
		lightShaderParams.isFirstDiffLight = false;
	}
}

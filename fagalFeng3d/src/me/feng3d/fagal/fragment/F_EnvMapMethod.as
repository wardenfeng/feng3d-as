package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.params.EnvShaderParams;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 *
	 * @author feng 2015-9-5
	 */
	public function F_EnvMapMethod():void
	{
		var _:* = FagalRE.instance.space;
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var envShaderParams:EnvShaderParams = shaderParams.getOrCreateComponentByClass(EnvShaderParams);

		var dataRegister:Register = _.envMapData_fc_vector;
		var temp:Register = _.getFreeTemp("");
		var cubeMapReg:Register = _.envMapcubeTexture_fs;
		var temp2:Register = _.getFreeTemp("");

		var targetReg:Register = _.finalColor_ft_4;

		// r = I - 2(I.N)*N
		_.dp3(temp.w, _.viewDir_ft_4.xyz, _.normal_ft_4.xyz);
		_.add(temp.w, temp.w, temp.w);
		_.mul(temp.xyz, _.normal_ft_4.xyz, temp.w);
		_.sub(temp.xyz, temp.xyz, _.viewDir_ft_4.xyz);

		//有些没看懂..................................
		_.tex(temp, temp, cubeMapReg);

		_.sub(temp2.w, temp.w, _.commonsData_fc_vector.x); // -.5
		_.kil(temp2.w); // used for real time reflection mapping - if alpha is not 1 (mock texture) kil output
		_.sub(temp, temp, targetReg);

		if (envShaderParams.useEnvMapMask)
		{
			_.tex(temp2, _.uv_v, _.envMapMaskTexture_fs);
			_.mul(temp, temp2, temp);
		}
		_.mul(temp, temp, dataRegister.x);
		_.add(targetReg, targetReg, temp);
	}
}



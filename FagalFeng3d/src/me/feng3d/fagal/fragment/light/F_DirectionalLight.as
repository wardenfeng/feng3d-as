package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 方向光渲染函数
	 * @author warden_feng 2014-11-7
	 */
	public function F_DirectionalLight():void
	{
		var _:* = FagalRE.instance.space;

		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var numDirectionalLights:int = shaderParams.numDirectionalLights;

		//遍历处理每个方向光
		for (var i:uint = 0; i < numDirectionalLights; ++i)
		{
			//灯光方向寄存器
			var lightDirReg:Register = _.dirLightSceneDir_fc_vector.getReg(i);
			//漫反射颜色寄存器
			var diffuseColorReg:Register = _.dirLightDiffuse_fc_vector.getReg(i);
			//镜面反射颜色寄存器
			var specularColorReg:Register = _.dirLightSpecular_fc_vector.getReg(i);

			//处理每个光的漫反射
			if (shaderParams.usingDiffuseMethod > 0)
			{
				getDiffCodePerLight(lightDirReg, diffuseColorReg);
			}
			//处理每个光的镜面反射
			if (shaderParams.usingSpecularMethod > 0)
			{
				getSpecCodePerLight(lightDirReg, specularColorReg);
			}
		}
	}
}

package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterVector;
	import me.feng3d.fagal.base.requestRegisterVector;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.methods.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsLight;

	/**
	 * 方向光渲染函数
	 * @author warden_feng 2014-11-7
	 */
	public function F_DirectionalLight():void
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var shaderParamsLight:ShaderParamsLight = shaderParams.getComponent(ShaderParamsLight.NAME);
		var numDirectionalLights:int = shaderParamsLight.numDirectionalLights;

		//方向光源场景方向
		var dirLightDirHeadReg:RegisterVector = requestRegisterVector(Context3DBufferTypeID.DIRLIGHTSCENEDIR_FC_VECTOR, numDirectionalLights);
		//方向光源漫反射光颜色
		var dirLightDiffuseColorHeadReg:RegisterVector = requestRegisterVector(Context3DBufferTypeID.DIRLIGHTDIFFUSE_FC_VECTOR, numDirectionalLights);
		//方向光源镜面反射颜色
		var dirLightSpecularColorHeadReg:RegisterVector = requestRegisterVector(Context3DBufferTypeID.DIRLIGHTSPECULAR_FC_VECTOR, numDirectionalLights);

		//遍历处理每个方向光
		for (var i:uint = 0; i < numDirectionalLights; ++i)
		{
			//灯光方向寄存器
			var lightDirReg:Register = dirLightDirHeadReg.getReg(i);
			//漫反射颜色寄存器
			var diffuseColorReg:Register = dirLightDiffuseColorHeadReg.getReg(i);
			//镜面反射颜色寄存器
			var specularColorReg:Register = dirLightSpecularColorHeadReg.getReg(i);

			//处理每个光的漫反射
			if (shaderParams.usingDiffuseMethod > 0)
			{
				getDiffCodePerLight(lightDirReg, diffuseColorReg);
			}
			//处理每个光的镜面反射
			if (shaderParamsLight.usingSpecularMethod > 0)
			{
				getSpecCodePerLight(lightDirReg, specularColorReg);
			}
		}
	}
}

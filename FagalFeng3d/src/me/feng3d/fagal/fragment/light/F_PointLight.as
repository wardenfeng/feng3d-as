package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterVector;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.requestRegisterVector;
	import me.feng3d.fagal.base.operation.dp3;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.base.operation.nrm;
	import me.feng3d.fagal.base.operation.sat;
	import me.feng3d.fagal.base.operation.sub;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.methods.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsCommon;
	import me.feng3d.fagal.params.ShaderParamsLight;

	/**
	 * 点光源渲染
	 * @author warden_feng 2014-11-8
	 */
	public function F_PointLight():void
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var shaderParamsLight:ShaderParamsLight = shaderParams.getComponent(ShaderParamsLight.NAME);

		//世界坐标变量
		var globalPosVaryReg:Register = requestRegister(Context3DBufferTypeID.GLOBALPOS_V);

		var numPointLights:int = shaderParamsLight.numPointLights;
		//
		//点光源漫反射光颜色
		var pointLightDiffuseColorHeadReg:RegisterVector = requestRegisterVector(Context3DBufferTypeID.POINTLIGHTDIFFUSE_FC_VECTOR, numPointLights);
		//点光源场景位置
		var pointLightScenePosHeadReg:RegisterVector = requestRegisterVector(Context3DBufferTypeID.POINTLIGHTSCENEPOS_FC_VECTOR, numPointLights);
		//点光源镜面反射颜色
		var pointLightSpecularColorHeadReg:RegisterVector = requestRegisterVector(Context3DBufferTypeID.POINTLIGHTSPECULAR_FC_VECTOR, numPointLights);
		//光线方向
		var pointLightDirReg:Register;
		//点光源漫反射颜色寄存器
		var pointLightdiffuseColorReg:Register;
		//点光源镜面反射颜色寄存器
		var pointLightSpecularColorReg:Register;
		//点光源世界坐标寄存器
		var pointLightPosReg:Register;

		pointLightDirReg = getFreeTemp("光照方向");
		//遍历点光源
		for (var i:uint = 0; i < numPointLights; ++i)
		{
			pointLightPosReg = pointLightScenePosHeadReg.getReg(i);
			pointLightdiffuseColorReg = pointLightDiffuseColorHeadReg.getReg(i);
			pointLightSpecularColorReg = pointLightSpecularColorHeadReg.getReg(i);

			comment("计算光照方向与光强");
			// 计算光衰减 （根据物体表面离光源的距离来计算光强）
			//物体表面到光源距离
			sub(pointLightDirReg, pointLightPosReg, globalPosVaryReg);
			// attenuate
			dp3(pointLightDirReg.w, pointLightDirReg, pointLightDirReg);
			// w = d - radis
			sub(pointLightDirReg.w, pointLightDirReg.w, pointLightdiffuseColorReg.w);
			// w = (d - radius)/(max-min) 
			mul(pointLightDirReg.w, pointLightDirReg.w, pointLightSpecularColorReg.w);
			// w = clamp(w, 0, 1)
			sat(pointLightDirReg.w, pointLightDirReg.w);
			// w = 1-w (w为光强)
			sub(pointLightDirReg.w, pointLightPosReg.w, pointLightDirReg.w);
			// normalize
			nrm(pointLightDirReg.xyz, pointLightDirReg); //

			//通用渲染参数
			var common:ShaderParamsCommon = shaderParams.getComponent(ShaderParamsCommon.NAME);

			//计算漫反射
			if (common.usingDiffuseMethod)
			{
				getDiffCodePerLight(pointLightDirReg, pointLightdiffuseColorReg);
			}
			//计算镜面反射
			if (shaderParamsLight.usingSpecularMethod)
			{
				getSpecCodePerLight(pointLightDirReg, pointLightSpecularColorReg);
			}
		}

		removeTemp(pointLightDirReg);
	}
}

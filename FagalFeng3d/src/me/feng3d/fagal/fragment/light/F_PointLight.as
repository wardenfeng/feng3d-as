package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 点光源渲染
	 * @author warden_feng 2014-11-8
	 */
	public function F_PointLight():void
	{
		var _:* = FagalRE.instance.space;

		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;

		var numPointLights:int = shaderParams.numPointLights;
		//
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
			pointLightPosReg = _.pointLightScenePos_fc_vector.getReg(i);
			pointLightdiffuseColorReg = _.pointLightDiffuse_fc_vector.getReg(i);
			pointLightSpecularColorReg = _.pointLightSpecular_fc_vector.getReg(i);

			_.comment("计算光照方向与光强");
			// 计算光衰减 （根据物体表面离光源的距离来计算光强）
			//物体表面到光源距离
			_.sub(pointLightDirReg, pointLightPosReg, _.globalPos_v);
			// attenuate
			_.dp3(pointLightDirReg.w, pointLightDirReg, pointLightDirReg);
			// w = d - radis
			_.sub(pointLightDirReg.w, pointLightDirReg.w, pointLightdiffuseColorReg.w);
			// w = (d - radius)/(max-min) 
			_.mul(pointLightDirReg.w, pointLightDirReg.w, pointLightSpecularColorReg.w);
			// w = clamp(w, 0, 1)
			_.sat(pointLightDirReg.w, pointLightDirReg.w);
			// w = 1-w (w为光强)
			_.sub(pointLightDirReg.w, pointLightPosReg.w, pointLightDirReg.w);
			// normalize
			_.nrm(pointLightDirReg.xyz, pointLightDirReg); //

			//计算漫反射
			if (shaderParams.usingDiffuseMethod)
			{
				getDiffCodePerLight(pointLightDirReg, pointLightdiffuseColorReg);
			}
			//计算镜面反射
			if (shaderParams.usingSpecularMethod)
			{
				getSpecCodePerLight(pointLightDirReg, pointLightSpecularColorReg);
			}
		}

		removeTemp(pointLightDirReg);
	}
}

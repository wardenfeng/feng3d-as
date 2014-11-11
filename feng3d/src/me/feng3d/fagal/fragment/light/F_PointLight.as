package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterVector;

	/**
	 * 点光源渲染
	 * @author warden_feng 2014-11-8
	 */
	[FagalMethod(methodType = "fragment")]
	public class F_PointLight extends F_BaseLight
	{
		[Register(regName = "pointLightDiffuse_fc_vector", regType = "uniform", regNum = "numPointLights", description = "点光源漫反射光颜色")]
		public var pointLightDiffuseColorHeadReg:RegisterVector;

		[Register(regName = "pointLightScenePos_fc_vector", regType = "uniform", regNum = "numPointLights", description = "点光源场景位置")]
		public var pointLightScenePosHeadReg:RegisterVector;

		[Register(regName = "pointLightSpecular_fc_vector", regType = "uniform", regNum = "numPointLights", description = "点光源镜面反射颜色")]
		public var pointLightSpecularColorHeadReg:RegisterVector;

		[Register(regName = "globalPos_v", regType = "in", description = "世界坐标变量")]
		public var globalPosVaryReg:Register;

		public function get numPointLights():int
		{
			return shaderParams.numPointLights;
		}

		override public function runFunc():void
		{
			//光线方向
			var pointLightDirReg:Register;
			//点光源漫反射颜色寄存器
			var pointLightdiffuseColorReg:Register;
			//点光源镜面反射颜色寄存器
			var pointLightSpecularColorReg:Register;
			//点光源世界坐标寄存器
			var pointLightPosReg:Register;

			var regIndex:int;

			pointLightDirReg = getFreeTemp("光照方向");
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

				//计算漫反射
				if (shaderParams.usingDiffuseMethod)
					getDiffCodePerLight(pointLightDirReg, pointLightdiffuseColorReg, i == 0);
				//计算镜面反射
				if (shaderParams.usingSpecularMethod)
					getSpecCodePerLight(pointLightDirReg, pointLightSpecularColorReg, i == 0);
			}
			
			removeTemp(pointLightDirReg);
		}
	}
}

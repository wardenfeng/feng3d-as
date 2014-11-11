package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterVector;

	/**
	 * 方向光渲染函数
	 * @author warden_feng 2014-11-7
	 */
	[FagalMethod(methodType = "fragment")]
	public class F_DirectionalLight extends F_BaseLight
	{
		[Register(regName = "dirLightDiffuse_fc_vector", regType = "uniform", regNum = "numDirectionalLights", description = "方向光源漫反射光颜色")]
		public var dirLightDiffuseColorHeadReg:RegisterVector;

		[Register(regName = "dirLightSceneDir_fc_vector", regType = "uniform", regNum = "numDirectionalLights", description = "方向光源场景方向")]
		public var dirLightDirHeadReg:RegisterVector;

		[Register(regName = "dirLightSpecular_fc_vector", regType = "uniform", regNum = "numDirectionalLights", description = "方向光源镜面反射颜色")]
		public var dirLightSpecularColorHeadReg:RegisterVector;

		public function get numDirectionalLights():int
		{
			return shaderParams.numDirectionalLights;
		}

		override public function runFunc():void
		{
			var lightDirReg:Register;
			var diffuseColorReg:Register;
			var specularColorReg:Register;

			for (var i:uint = 0; i < numDirectionalLights; ++i)
			{
				lightDirReg = dirLightDirHeadReg.getReg(i);
				diffuseColorReg = dirLightDiffuseColorHeadReg.getReg(i);
				specularColorReg = dirLightSpecularColorHeadReg.getReg(i);

				if (shaderParams.usingDiffuseMethod)
					getDiffCodePerLight(lightDirReg, diffuseColorReg, i == 0);
				if (shaderParams.usingSpecularMethod)
					getSpecCodePerLight(lightDirReg, specularColorReg, i == 0);
			}
		}
	}
}

package me.feng3d.fagal.fragment
{
	import me.feng3d.fagal.fragment.light.F_Ambient;
	import me.feng3d.fagal.fragment.light.F_DirectionalLight;
	import me.feng3d.fagal.fragment.light.F_PointLight;
	import me.feng3d.fagal.fragment.light.F_SpecularPostLighting;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 片段渲染程序主入口
	 * @author warden_feng 2014-10-30
	 */
	[FagalMethod(methodType = "fragment")]
	public class F_Main extends FagalMethod
	{
		override public function runFunc():void
		{
			if (shaderParams.needsNormals)
				if (shaderParams.hasNormalTexture)
					call(F_TangentNormalMap);
				else
					call(F_TangentNormalNoMap);

			if (shaderParams.needsViewDir)
				call(F_ViewDir);

			if (shaderParams.numDirectionalLights)
				call(F_DirectionalLight);
			if (shaderParams.numPointLights)
				call(F_PointLight);

			if (shaderParams.usingDiffuseMethod)
				call(shaderParams.diffuseMethod);

			if (shaderParams.numLights > 0)
			{
				if (shaderParams.usingSpecularMethod)
					call(F_SpecularPostLighting);
				call(F_Ambient);
			}

			call(F_FinalOut);
//			if (shaderParams.hasDiffuseTexture)
//				call(F_BaseOut);
//			else
//			{
//				call(F_DiffusePostLighting);
//			}
		}
	}
}

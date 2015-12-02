package me.feng3d.fagal.fragment
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.fagal.fragment.light.F_AlphaPremultiplied;
	import me.feng3d.fagal.fragment.light.F_Ambient;
	import me.feng3d.fagal.fragment.light.F_DirectionalLight;
	import me.feng3d.fagal.fragment.light.F_PointLight;
	import me.feng3d.fagal.fragment.light.F_SpecularPostLighting;
	import me.feng3d.fagal.fragment.particle.F_Particles;
	import me.feng3d.fagal.fragment.shadowMap.F_ShadowMap;
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagal.params.CommonShaderParams;
	import me.feng3d.fagal.params.EnvShaderParams;
	import me.feng3d.fagal.params.FogShaderParams;
	import me.feng3d.fagal.params.LightShaderParams;
	import me.feng3d.fagal.params.ShadowShaderParams;

	/**
	 * 片段渲染程序主入口
	 * @author feng 2014-10-30
	 */
	public class F_Main extends FagalMethod
	{
		/**
		 * 创建片段渲染程序主入口
		 */
		public function F_Main()
		{
			_shaderType = Context3DProgramType.FRAGMENT;
		}

		/**
		 * @inheritDoc
		 */
		override public function runFunc():void
		{
			shaderParams.preRunParams();
			var commonShaderParams:CommonShaderParams = shaderParams.getComponentByClass(CommonShaderParams);
			var lightShaderParams:LightShaderParams = shaderParams.getComponentByClass(LightShaderParams);
			var shadowShaderParams:ShadowShaderParams = shaderParams.getComponentByClass(ShadowShaderParams);
			var fogShaderParams:FogShaderParams = shaderParams.getComponentByClass(FogShaderParams);
			var envShaderParams:EnvShaderParams = shaderParams.getComponentByClass(EnvShaderParams);

			//计算法线
			if (lightShaderParams.needsNormals > 0)
			{
				if (lightShaderParams.hasNormalTexture)
				{
					F_TangentNormalMap();
				}
				else
				{
					F_TangentNormalNoMap();
				}
			}

			//光泽图采样
			if (lightShaderParams.hasSpecularTexture > 0)
			{
				F_SpecularSample();
			}

			//计算视线
			if (lightShaderParams.needsViewDir > 0)
			{
				F_ViewDir();
			}

			//处理方向灯光
			if (lightShaderParams.numDirectionalLights > 0)
			{
				F_DirectionalLight();
			}

			//处理点灯光
			if (lightShaderParams.numPointLights > 0)
			{
				F_PointLight();
			}

			//计算环境光
			if (lightShaderParams.numLights > 0)
			{
				F_Ambient();
			}

			//渲染阴影
			if (shadowShaderParams.usingShadowMapMethod > 0)
			{
				F_ShadowMap();
			}

			//计算漫反射
			if (commonShaderParams.usingDiffuseMethod)
			{
				lightShaderParams.diffuseMethod();
			}

			if (shaderParams.alphaPremultiplied)
			{
				F_AlphaPremultiplied();
			}

			if (lightShaderParams.numLights > 0 && lightShaderParams.usingSpecularMethod > 0)
			{
				F_SpecularPostLighting();
			}

			//调用粒子相关片段渲染程序
			F_Particles();

			if (envShaderParams.useEnvMapMethod > 0)
			{
				F_EnvMapMethod()
			}

			if (fogShaderParams.useFog > 0)
			{
				F_Fog();
			}

			F_FinalOut();
		}
	}
}



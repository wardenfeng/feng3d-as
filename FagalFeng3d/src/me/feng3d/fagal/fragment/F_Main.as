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

	/**
	 * 片段渲染程序主入口
	 * @author warden_feng 2014-10-30
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

			//计算法线
			if (shaderParams.needsNormals > 0)
			{
				if (shaderParams.hasNormalTexture)
				{
					F_TangentNormalMap();
				}
				else
				{
					F_TangentNormalNoMap();
				}
			}

			//光泽图采样
			if (shaderParams.hasSpecularTexture > 0)
			{
				F_SpecularSample();
			}

			//计算视线
			if (shaderParams.needsViewDir > 0)
			{
				F_ViewDir();
			}

			//处理方向灯光
			if (shaderParams.numDirectionalLights > 0)
			{
				F_DirectionalLight();
			}

			//处理点灯光
			if (shaderParams.numPointLights > 0)
			{
				F_PointLight();
			}

			//计算环境光
			if (shaderParams.numLights > 0)
			{
				F_Ambient();
			}

			//渲染阴影
			if (shaderParams.usingShadowMapMethod > 0)
			{
				F_ShadowMap();
			}

			//计算漫反射
			if (shaderParams.usingDiffuseMethod)
			{
				shaderParams.diffuseMethod();
			}

			if (shaderParams.alphaPremultiplied)
			{
				F_AlphaPremultiplied();
			}

			if (shaderParams.numLights > 0 && shaderParams.usingSpecularMethod > 0)
			{
				F_SpecularPostLighting();
			}

			//调用粒子相关片段渲染程序
			F_Particles();

			if (shaderParams.useEnvMapMethod > 0)
			{
				F_EnvMapMethod()
			}

			if (shaderParams.useFog > 0)
			{
				F_Fog();
			}

			F_FinalOut();
		}
	}
}



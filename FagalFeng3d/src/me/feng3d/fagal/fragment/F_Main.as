package me.feng3d.fagal.fragment
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.fragment.light.F_Ambient;
	import me.feng3d.fagal.fragment.light.F_DirectionalLight;
	import me.feng3d.fagal.fragment.light.F_PointLight;
	import me.feng3d.fagal.fragment.light.F_SpecularPostLighting;
	import me.feng3d.fagal.fragment.particle.F_Particles;
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagal.params.ShaderParamsCommon;
	import me.feng3d.fagal.params.ShaderParamsLight;
	import me.feng3d.fagal.params.ShaderParamsParticle;
	import me.feng3d.fagal.params.ShaderParamsShadowMap;
	import me.feng3d.fagal.fragment.shadowMap.F_ShadowMap;

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
			shaderParams.preRun();

			var shaderParamsLight:ShaderParamsLight = shaderParams.getComponent(ShaderParamsLight.NAME);

			//计算法线
			if (shaderParamsLight.needsNormals > 0)
			{
				if (shaderParamsLight.hasNormalTexture)
				{
					F_TangentNormalMap();
				}
				else
				{
					F_TangentNormalNoMap();
				}
			}

			//光泽图采样
			if (shaderParamsLight.hasSpecularTexture)
			{
				F_SpecularSample();
			}

			//计算视线
			if (shaderParamsLight.needsViewDir)
			{
				F_ViewDir();
			}

			//处理方向灯光
			if (shaderParamsLight.numDirectionalLights > 0)
			{
				F_DirectionalLight();
			}

			//处理点灯光
			if (shaderParamsLight.numPointLights > 0)
			{
				F_PointLight();
			}

			//通用渲染参数
			var common:ShaderParamsCommon = shaderParams.getComponent(ShaderParamsCommon.NAME);

			//计算环境光
			if (shaderParamsLight.numLights > 0)
			{
				F_Ambient();
			}

			//渲染阴影
			var shaderParamsShadowMap:ShaderParamsShadowMap = shaderParams.getComponent(ShaderParamsShadowMap.NAME);
			if (shaderParamsShadowMap.usingShadowMapMethod > 0)
			{
				F_ShadowMap();
			}

			//计算漫反射
			if (common.usingDiffuseMethod)
			{
				shaderParamsLight.diffuseMethod();
			}

			if (shaderParamsLight.numLights > 0 && shaderParamsLight.usingSpecularMethod > 0)
			{
				F_SpecularPostLighting();
			}

			/** 粒子渲染参数 */
			var particleShaderParam:ShaderParamsParticle = shaderParams.getComponent(ShaderParamsParticle.NAME);
			//调用粒子相关片段渲染程序
			if (particleShaderParam != null)
			{
				F_Particles();
			}

			F_FinalOut();
		}
	}
}



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
					//切线变量寄存器
					var tangentVarying:Register = requestRegister(Context3DBufferTypeID.TANGENT_V);
					//双切线变量寄存器
					var bitangentVarying:Register = requestRegister(Context3DBufferTypeID.BITANGENT_V);
					//法线变量寄存器
					var normalVarying:Register = requestRegister(Context3DBufferTypeID.NORMAL_V);
					//法线纹理数据片段临时寄存器
					var normalTexData:Register = requestRegister("normalTexData_ft_4");
					//法线临时片段寄存器
					var normalFragment:Register = requestRegister(Context3DBufferTypeID.NORMAL_FT_4);

					F_TangentNormalMap(tangentVarying, bitangentVarying, normalVarying, normalTexData, normalFragment);
				}
				else
				{
					//法线变量寄存器
					var normalVaryingReg:Register = requestRegister(Context3DBufferTypeID.NORMAL_V);
					//法线临时片段寄存器
					var normalFragmentReg:Register = requestRegister(Context3DBufferTypeID.NORMAL_FT_4);
					F_TangentNormalNoMap(normalVaryingReg, normalFragmentReg);
				}
			}

			//光泽图采样
			if (shaderParamsLight.hasSpecularTexture)
			{
				//光泽纹理寄存器
				var specularFragmentReg:Register = requestRegister(Context3DBufferTypeID.SPECULARTEXTURE_FS);
				//uv变量数据
				var uv:Register = requestRegister(Context3DBufferTypeID.UV_V);
				//光泽纹理数据片段临时寄存器
				var specularTexData:Register = requestRegister("specularTexData_ft_4");

				F_SpecularSample(specularFragmentReg, uv, specularTexData);
			}

			//计算视线
			if (shaderParamsLight.needsViewDir)
			{
				//视线变量寄存器
				var viewDirVaryingReg:Register = requestRegister(Context3DBufferTypeID.VIEWDIR_V);
				//视线方向片段临时数据
				var viewDirFragmentReg:Register = requestRegister(Context3DBufferTypeID.VIEWDIR_FT_4);
				F_ViewDir(viewDirVaryingReg, viewDirFragmentReg);
			}

			//处理方向灯光
			if (shaderParamsLight.numDirectionalLights > 0)
			{
				F_DirectionalLight();
			}

			//处理点灯光
			if (shaderParamsLight.numPointLights > 0)
			{
				//世界坐标变量
				var globalPosVaryReg:Register = requestRegister(Context3DBufferTypeID.GLOBALPOS_V);
				F_PointLight(globalPosVaryReg);
			}

			//通用渲染参数
			var common:ShaderParamsCommon = shaderParams.getComponent(ShaderParamsCommon.NAME);

			//计算环境光
			if (shaderParamsLight.numLights > 0)
			{
				//环境输入静态数据
				var ambientInputReg:Register = requestRegister(Context3DBufferTypeID.AMBIENTINPUT_FC_VECTOR);
				var ambientTempReg:Register = requestRegister(Context3DBufferTypeID.AMBIENT_FT);
				F_Ambient(ambientInputReg, ambientTempReg);
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

			//最终颜色寄存器（输出到oc寄存器的颜色）
			var finalColorReg:Register = requestRegister(Context3DBufferTypeID.FINALCOLOR_FT_4);

			if (shaderParamsLight.numLights > 0 && shaderParamsLight.usingSpecularMethod > 0)
			{
				//总漫反射颜色寄存器
				var totalSpecularColorReg:Register = requestRegister(Context3DBufferTypeID.TOTALSPECULARLIGHTCOLOR_FT_4);
				//材质镜面反射光数据 
				var _specularDataRegister:Register = requestRegister(Context3DBufferTypeID.SPECULARDATA_FC_VECTOR);
				F_SpecularPostLighting(totalSpecularColorReg, finalColorReg, specularTexData, _specularDataRegister);
			}

			/** 粒子渲染参数 */
			var particleShaderParam:ShaderParamsParticle = shaderParams.getComponent(ShaderParamsParticle.NAME);
			//调用粒子相关片段渲染程序
			if (particleShaderParam != null)
			{
				F_Particles();
			}

			//颜色输出寄存器
			var out:Register = requestRegister(Context3DBufferTypeID.OC);
			F_FinalOut(finalColorReg, out);
		}
	}
}



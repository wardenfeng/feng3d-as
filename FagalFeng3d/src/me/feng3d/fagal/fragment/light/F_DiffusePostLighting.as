package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.base.operation.sat;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.fragment.F_DiffuseColor;
	import me.feng3d.fagal.fragment.F_DiffuseTexure;
	import me.feng3d.fagal.methods.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsCommon;
	import me.feng3d.fagal.params.ShaderParamsLight;
	import me.feng3d.fagal.params.ShaderParamsShadowMap;

	/**
	 * 发布漫反射光
	 * @author warden_feng 2014-11-7
	 */
	public function F_DiffusePostLighting():void
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		//通用渲染参数
		var common:ShaderParamsCommon = shaderParams.getComponent(ShaderParamsCommon.NAME);
		var shaderParamsLight:ShaderParamsLight = shaderParams.getComponent(ShaderParamsLight.NAME);

		//总漫反射颜色寄存器
		var totalLightColorReg:Register = requestRegister(Context3DBufferTypeID.TOTALDIFFUSELIGHTCOLOR_FT_4);
		//材质的漫反射颜色
		var mdiffReg:Register = requestRegister(Context3DBufferTypeID.MDIFF_FT);
		//最终颜色寄存器（输出到oc寄存器的颜色）
		var finalColorReg:Register = requestRegister(Context3DBufferTypeID.FINALCOLOR_FT_4);

		var shaderParamsShadowMap:ShaderParamsShadowMap = shaderParams.getComponent(ShaderParamsShadowMap.NAME);

		//把阴影使用到漫反射光上
		if (shaderParamsLight.numLights > 0 && shaderParamsShadowMap.needsShadowRegister > 0)
		{
			var shadowValueReg:Register = requestRegister(Context3DBufferTypeID.SHADOWVALUE_FT_4);
			mul(totalLightColorReg.xyz, totalLightColorReg, shadowValueReg.w);
		}

		//获取漫反射灯光
		if (common.hasDiffuseTexture)
		{
			//片段程序的纹理
			var diffuseTexReg:Register = requestRegister(Context3DBufferTypeID.TEXTURE_FS);
			//uv变量数据
			var uvReg:Register = requestRegister(Context3DBufferTypeID.UV_V);
			F_DiffuseTexure(diffuseTexReg, uvReg, mdiffReg);
		}
		else
		{
			//漫射输入静态数据
			var diffColorReg:Register = requestRegister(Context3DBufferTypeID.DIFFUSEINPUT_FC_VECTOR);
			F_DiffuseColor(diffColorReg, mdiffReg);
		}

		if (shaderParamsLight.numLights == 0)
		{
			mov(finalColorReg, mdiffReg);
			return;
		}

		//控制在0到1之间
		sat(totalLightColorReg, totalLightColorReg);

		//漫反射 + 环境光 因子
		var ambientTempReg:Register = requestRegister(Context3DBufferTypeID.AMBIENT_FT);
		add(totalLightColorReg.xyz, totalLightColorReg, ambientTempReg);

		//混合漫反射光
		mul(finalColorReg.xyz, mdiffReg, totalLightColorReg);
		//保存w值不变
		mov(finalColorReg.w, mdiffReg.w);

		removeTemp(totalLightColorReg);
	}
}

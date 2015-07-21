package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.dp3;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.base.operation.nrm;
	import me.feng3d.fagal.base.operation.pow;
	import me.feng3d.fagal.base.operation.sat;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.methods.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsLight;

	/**
	 * 计算单个镜面反射光
	 * @author warden_feng 2015-4-24
	 */
	public function getSpecCodePerLight(lightDirReg:Register, specularColorReg:Register):void
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var shaderParamsLight:ShaderParamsLight = shaderParams.getComponent(ShaderParamsLight.NAME);

		//总镜面反射颜色寄存器
		var totalSpecularColorReg:Register = requestRegister(Context3DBufferTypeID.TOTALSPECULARLIGHTCOLOR_FT_4);
		//法线临时片段寄存器
		var normalFragmentReg:Register = requestRegister(Context3DBufferTypeID.NORMAL_FT_4);
		//视线方向片段临时数据
		var viewDirReg:Register = requestRegister(Context3DBufferTypeID.VIEWDIR_FT_4);
		//材质镜面反射光数据
		var _specularDataRegister:Register = requestRegister(Context3DBufferTypeID.SPECULARDATA_FC_VECTOR);

		//镜面反射光原理
		//法线 = 入射光方向 - 反射光方向------------1
		//物理光学已知：当视线方向与反射光方向相反时，反射光达到最亮。反射光强度和（反射光方向与-视线方向 的 夹角余弦值）相关
		//反射光方向与-视线 的 夹角 ---(代入1)--> (入射光方向 - 法线) 与 -视线 的 夹角 ----> 入射光方向+视线 与 法线的夹角
		//反射光方向与-视线方向 的 夹角余弦值 == 入射光方向+视线 与 法线 的 夹角余弦值  == 反射光强度

		var singleSpecularColorReg:Register;
		if (shaderParamsLight.isFirstSpecLight)
		{
			singleSpecularColorReg = totalSpecularColorReg;
		}
		else
		{
			singleSpecularColorReg = getFreeTemp("单个镜面反射光寄存器");
		}

		//入射光与视线方向的和 = 光照场景方向 add 标准视线方向
		add(singleSpecularColorReg, lightDirReg, viewDirReg);
		//标准化入射光与视线的和
		nrm(singleSpecularColorReg.xyz, singleSpecularColorReg);
		//镜面反射光强度 = 法线 dp3 入射光与视线方向的和
		dp3(singleSpecularColorReg.w, normalFragmentReg, singleSpecularColorReg);
		//镜面反射光强度 锁定在0-1之间
		sat(singleSpecularColorReg.w, singleSpecularColorReg.w);

		if (shaderParamsLight.hasSpecularTexture)
		{
			//使用光照图调整高光
			//光泽纹理数据片段临时寄存器
			var specularTexData:Register = requestRegister(Context3DBufferTypeID.SPECULARTEXDATA_FT_4);
			mul(specularTexData.w, specularTexData.y, _specularDataRegister.w);
			pow(singleSpecularColorReg.w, singleSpecularColorReg.w, specularTexData.w);
		}
		else
		{
			//镜面反射光强度 = 镜面反射光强度 pow 光泽度
			pow(singleSpecularColorReg.w, singleSpecularColorReg.w, _specularDataRegister.w);
		}

		if (shaderParamsLight.useLightFallOff)
		{
			//镜面反射光强度 = 镜面反射强度  nul (入射光强度？)
			mul(singleSpecularColorReg.w, singleSpecularColorReg.w, lightDirReg.w);
		}

		comment("镜面反射光颜色 = 灯光镜面反射颜色 mul 镜面反射光强度");
		mul(singleSpecularColorReg.xyz, specularColorReg, singleSpecularColorReg.w);

		//叠加镜面反射光
		if (!shaderParamsLight.isFirstSpecLight)
		{
			//总镜面反射光 = 总镜面反射光 + 单个镜面反射光
			add(totalSpecularColorReg.xyz, totalSpecularColorReg, singleSpecularColorReg);
			removeTemp(singleSpecularColorReg);
		}
		shaderParamsLight.isFirstSpecLight = false;
	}
}

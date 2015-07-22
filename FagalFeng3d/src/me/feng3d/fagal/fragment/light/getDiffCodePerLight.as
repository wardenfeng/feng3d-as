package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.dp3;
	import me.feng3d.fagal.base.operation.max;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.methods.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;

	/**
	 * 处理
	 * @author warden_feng 2015-4-24
	 */
	public function getDiffCodePerLight(lightDirReg:Register, diffuseColorReg:Register):void
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;

		//总漫反射颜色寄存器
		var totalDiffLightColorReg:Register = requestRegister(Context3DBufferTypeID.TOTALDIFFUSELIGHTCOLOR_FT_4);
		//法线临时片段寄存器
		var normalFragmentReg:Register = requestRegister(Context3DBufferTypeID.NORMAL_FT_4);
		//公用数据片段常量数据
		var commonsReg:Register = requestRegister(Context3DBufferTypeID.COMMONSDATA_FC_VECTOR);

		var diffuseColorFtReg:Register;
		if (shaderParams.isFirstDiffLight)
		{
			diffuseColorFtReg = totalDiffLightColorReg;
		}
		else
		{
			diffuseColorFtReg = getFreeTemp("单个漫反射光寄存器")
		}

		//计算灯光方向与法线夹角
		dp3(diffuseColorFtReg.x, lightDirReg, normalFragmentReg);
		//过滤负数
		max(diffuseColorFtReg.w, diffuseColorFtReg.x, commonsReg.y);

		//灯光衰减
		if (shaderParams.useLightFallOff)
			mul(diffuseColorFtReg.w, diffuseColorFtReg.w, lightDirReg.w);

		comment("漫反射光颜色 = 灯光漫反射颜色 mul 漫反射光强度");
		mul(diffuseColorFtReg, diffuseColorReg, diffuseColorFtReg.w);

		//叠加灯光
		if (!shaderParams.isFirstDiffLight)
		{
			add(totalDiffLightColorReg.xyz, totalDiffLightColorReg, diffuseColorFtReg);
			removeTemp(diffuseColorFtReg);
		}
		shaderParams.isFirstDiffLight = false;
	}
}

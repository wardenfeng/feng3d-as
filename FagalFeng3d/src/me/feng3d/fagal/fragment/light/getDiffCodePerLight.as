package me.feng3d.fagal.fragment.light
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.dp3;
	import me.feng3d.fagal.base.operation.max;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 处理
	 * @author warden_feng 2015-4-24
	 */
	public function getDiffCodePerLight(lightDirReg:Register, diffuseColorReg:Register):void
	{
		var _:* = FagalRE.instance.space;

		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;

		var diffuseColorFtReg:Register;
		if (shaderParams.isFirstDiffLight)
		{
			diffuseColorFtReg = _.totalDiffuseLightColor_ft_4;
		}
		else
		{
			diffuseColorFtReg = getFreeTemp("单个漫反射光寄存器")
		}

		//计算灯光方向与法线夹角
		dp3(diffuseColorFtReg.x, lightDirReg, _.normal_ft_4);
		//过滤负数
		max(diffuseColorFtReg.w, diffuseColorFtReg.x, _.commonsData_fc_vector.y);

		//灯光衰减
		if (shaderParams.useLightFallOff)
			mul(diffuseColorFtReg.w, diffuseColorFtReg.w, lightDirReg.w);

		comment("漫反射光颜色 = 灯光漫反射颜色 mul 漫反射光强度");
		mul(diffuseColorFtReg, diffuseColorReg, diffuseColorFtReg.w);

		//叠加灯光
		if (!shaderParams.isFirstDiffLight)
		{
			add(_.totalDiffuseLightColor_ft_4.xyz, _.totalDiffuseLightColor_ft_4, diffuseColorFtReg);
			removeTemp(diffuseColorFtReg);
		}
		shaderParams.isFirstDiffLight = false;
	}
}

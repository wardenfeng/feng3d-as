package me.feng3d.fagal.fragment.shadowMap
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShadowShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 编译阴影映射片段程序
	 * @author feng 2015-6-23
	 */
	public function F_ShadowMap():void
	{
		var _:* = FagalRE.instance.space;

		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var shadowShaderParams:ShadowShaderParams = shaderParams.getComponent(ShadowShaderParams.NAME);

		F_ShadowMapSample();

		_.add(_.shadowValue_ft_4.w, _.shadowValue_ft_4.w, _.shadowCommondata1_fc_vector.y); //添加(1-阴影透明度)
		_.sat(_.shadowValue_ft_4.w, _.shadowValue_ft_4.w); //使阴影值在(0,1)区间内

		var temp:Register = _.getFreeTemp();

		if (shadowShaderParams.useNearShadowMap > 0)
		{
			//根据阴影离摄像机的距离计算阴影的透明度
			_.abs(temp, _.positionProjected_v.w); //获取顶点深度正值
			_.sub(temp, temp, _.secondary_fc_vector.x); //深度-最近可观察阴影距离
			_.mul(temp, temp, _.secondary_fc_vector.y); //计算衰减值
			_.sat(temp, temp); //
			_.sub(temp, _.secondary_fc_vector.w, temp); //ft5.x（阴影透明度）=1-衰减值
			_.sub(_.shadowValue_ft_4.w, _.secondary_fc_vector.w, _.shadowValue_ft_4.w); //ft0.w==1时为阴影
			_.mul(_.shadowValue_ft_4.w, _.shadowValue_ft_4.w, temp); //阴影乘以透明度
			_.sub(_.shadowValue_ft_4.w, _.secondary_fc_vector.w, _.shadowValue_ft_4.w); //ft0.w==0时为阴影
		}

	}
}

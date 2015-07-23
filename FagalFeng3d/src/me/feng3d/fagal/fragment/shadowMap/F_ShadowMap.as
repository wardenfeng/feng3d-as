package me.feng3d.fagal.fragment.shadowMap
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.abs;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.base.operation.sat;
	import me.feng3d.fagal.base.operation.sub;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;

	/**
	 * 编译阴影映射片段程序
	 * @author warden_feng 2015-6-23
	 */
	public function F_ShadowMap():void
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;

		var shadowValueReg:Register = requestRegister(Context3DBufferTypeID.shadowValue_ft_4);

		F_ShadowMapSample();

		var shadowCommondata1Reg:Register = requestRegister(Context3DBufferTypeID.shadowCommondata1_fc_vector);

		add(shadowValueReg.w, shadowValueReg.w, shadowCommondata1Reg.y); //添加(1-阴影透明度)
		sat(shadowValueReg.w, shadowValueReg.w); //使阴影值在(0,1)区间内

		var dataReg:Register = requestRegister(Context3DBufferTypeID.secondary_fc_vector);
		var temp:Register = getFreeTemp();
		var projectionFragment:Register = requestRegister(Context3DBufferTypeID.positionProjected_v);

		//根据阴影离摄像机的距离计算阴影的透明度
		abs(temp, projectionFragment.w); //获取顶点深度正值
		sub(temp, temp, dataReg.x); //深度-最近可观察阴影距离
		mul(temp, temp, dataReg.y); //计算衰减值
		sat(temp, temp); //
		sub(temp, dataReg.w, temp); //ft5.x（阴影透明度）=1-衰减值
		sub(shadowValueReg.w, dataReg.w, shadowValueReg.w); //ft0.w==1时为阴影
		mul(shadowValueReg.w, shadowValueReg.w, temp); //阴影乘以透明度
		sub(shadowValueReg.w, dataReg.w, shadowValueReg.w); //ft0.w==0时为阴影
	}
}

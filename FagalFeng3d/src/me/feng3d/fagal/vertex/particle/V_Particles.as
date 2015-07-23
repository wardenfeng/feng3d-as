package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;

	/**
	 * 粒子顶点渲染程序
	 * @author warden_feng 2014-11-14
	 */
	public function V_Particles():Register
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;

		var animatedPosition:Register = requestRegister(Context3DBufferTypeID.animatedPosition_vt_4);


		//粒子常数数据[0,1,2,0]
		var particleCommon:Register = requestRegister(Context3DBufferTypeID.particleCommon_vc_vector);
		//偏移坐标临时寄存器
		var positionTemp:Register;

		//初始化
		if (shaderParams.changePosition > 0)
		{
			//顶点坐标数据
			positionTemp = requestRegister("positionTemp_vt_4");
			var positionReg:Register = requestRegister(Context3DBufferTypeID.position_va_3);
			V_ParticlesInit(positionTemp, animatedPosition, positionReg, particleCommon);
		}

		//粒子颜色初始化
		if (shaderParams.changeColor > 0)
		{
			//粒子颜色偏移值，在片段渲染的最终颜色值上偏移
			var colorAddTarget:Register = requestRegister("particleColorOffset_vt_4");
			//粒子颜色乘数因子，用于乘以纹理上的颜色值
			var colorMulTarget:Register = requestRegister("particleColorMultiplier_vt_4");

			V_ParticlesInitColor(particleCommon, colorMulTarget, colorAddTarget);
		}

		//计算时间
		if (shaderParams.ParticleTimeLocalStatic)
		{
			//粒子时间属性数据
			var particleTimeVA:Register = requestRegister(Context3DBufferTypeID.particleTime_va_4);
			//特效当前时间
			var particleTimeVC:Register = requestRegister(Context3DBufferTypeID.particleTime_vc_vector);
			//粒子周期内时间临时寄存器
			var inCycleTimeTemp:Register = requestRegister("inCycleTime_vt_4");

			V_ParticlesTime(particleCommon, animatedPosition, particleTimeVA, particleTimeVC, inCycleTimeTemp);
		}

		//粒子速度节点顶点渲染程序
		if (shaderParams.ParticleVelocityGlobal)
		{
			//粒子速度数据
			var particleConstVelocity:Register = requestRegister(Context3DBufferTypeID.particleVelocity_vc_vector);
			V_ParticleVelocityGlobal(particleConstVelocity, positionTemp, inCycleTimeTemp);
		}
		//计算速度
		if (shaderParams.ParticleVelocityLocalStatic)
		{
			//粒子速度数据
			var particleVelocity:Register = requestRegister(Context3DBufferTypeID.particleVelocity_va_3);
			V_ParticleVelocity(particleVelocity, positionTemp, inCycleTimeTemp);
		}

		//粒子缩放节点顶点渲染程序
		if (shaderParams.ParticleScaleGlobal)
		{
			//粒子缩放数据
			var scaleRegister:Register = requestRegister(Context3DBufferTypeID.particleScale_vc_vector);
			V_ParticleScaleGlobal(scaleRegister, inCycleTimeTemp, animatedPosition);
		}

		//使用广告牌 朝向摄像机
		if (shaderParams.ParticleBillboardGlobal)
		{
			//广告牌旋转矩阵(3个长度向量形式)
			var particleBillboardMtx:Register = requestRegister(Context3DBufferTypeID.particleBillboard_vc_matrix);
			V_ParticleBillboard(particleBillboardMtx, animatedPosition);
		}

		//粒子颜色节点顶点渲染程序
		if (shaderParams.changeColor > 0)
		{
			//粒子颜色乘数因子增量值，用于计算粒子颜色乘数因子
			var deltaMultiplierValue:Register = requestRegister(Context3DBufferTypeID.particleDeltaColorMultiplier_vc_vector);
			//粒子颜色偏移起始值，用于计算粒子颜色偏移值
			var startOffsetValue:Register = requestRegister(Context3DBufferTypeID.particleStartColorOffset_vc_vector);
			//粒子颜色偏移增量值，用于计算粒子颜色偏移值
			var deltaOffsetValue:Register = requestRegister(Context3DBufferTypeID.particleDeltaColorOffset_vc_vector);
			//粒子颜色乘数因子起始值，用于计算粒子颜色乘数因子
			var startMultiplierValue:Register = requestRegister(Context3DBufferTypeID.particleStartColorMultiplier_vc_vector);

			V_ParticleColorGlobal(startMultiplierValue, deltaMultiplierValue, startOffsetValue, deltaOffsetValue, inCycleTimeTemp, colorMulTarget, colorAddTarget);
		}

		//结算坐标偏移
		if (shaderParams.changePosition > 0)
		{
			V_ParticlePositionEnd(animatedPosition, positionTemp);
		}

		//结算颜色
		if (shaderParams.ParticleColorGlobal)
		{
			//粒子颜色乘数因子，用于乘以纹理上的颜色值
			var colorMulVary:Register = requestRegister(Context3DBufferTypeID.particleColorMultiplier_v);

			//粒子颜色偏移值，在片段渲染的最终颜色值上偏移
			var colorAddVary:Register = requestRegister(Context3DBufferTypeID.particleColorOffset_v);

			V_ParticleColorEnd(colorMulTarget, colorAddTarget, colorMulVary, colorAddVary);
		}

		return animatedPosition;
	}
}

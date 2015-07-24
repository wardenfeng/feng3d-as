package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 粒子顶点渲染程序
	 * @author warden_feng 2014-11-14
	 */
	public function V_Particles():void
	{
		var _:* = FagalRE.instance.space;

		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;

		//初始化
		if (shaderParams.changePosition > 0)
		{
			V_ParticlesInit(_.particlePositionTemp_vt_4, _.animatedPosition_vt_4, _.position_va_3, _.particleCommon_vc_vector);
		}

		//粒子颜色初始化
		if (shaderParams.changeColor > 0)
		{
			V_ParticlesInitColor(_.particleCommon_vc_vector, _.particleColorMultiplier_vt_4, _.particleColorOffset_vt_4);
		}

		//计算时间
		if (shaderParams.ParticleTimeLocalStatic)
		{
			V_ParticlesTime(_.particleCommon_vc_vector, _.animatedPosition_vt_4, _.particleTime_va_4, _.particleTime_vc_vector, _.inCycleTime_vt_4);
		}

		//粒子速度节点顶点渲染程序
		if (shaderParams.ParticleVelocityGlobal)
		{
			V_ParticleVelocityGlobal(_.particleVelocity_vc_vector, _.particlePositionTemp_vt_4, _.inCycleTime_vt_4);
		}
		//计算速度
		if (shaderParams.ParticleVelocityLocalStatic)
		{
			V_ParticleVelocity(_.particleVelocity_va_3, _.particlePositionTemp_vt_4, _.inCycleTime_vt_4);
		}

		//粒子缩放节点顶点渲染程序
		if (shaderParams.ParticleScaleGlobal)
		{
			V_ParticleScaleGlobal(_.particleScale_vc_vector, _.inCycleTime_vt_4, _.animatedPosition_vt_4);
		}

		//使用广告牌 朝向摄像机
		if (shaderParams.ParticleBillboardGlobal)
		{
			V_ParticleBillboard(_.particleBillboard_vc_matrix, _.animatedPosition_vt_4);
		}

		//粒子颜色节点顶点渲染程序
		if (shaderParams.changeColor > 0)
		{
			V_ParticleColorGlobal(_.particleStartColorMultiplier_vc_vector, _.particleDeltaColorMultiplier_vc_vector, _.particleStartColorOffset_vc_vector, _.particleDeltaColorOffset_vc_vector, _.inCycleTime_vt_4, _.particleColorMultiplier_vt_4, _.particleColorOffset_vt_4);
		}

		//结算坐标偏移
		if (shaderParams.changePosition > 0)
		{
			V_ParticlePositionEnd(_.animatedPosition_vt_4, _.particlePositionTemp_vt_4);
		}

		//结算颜色
		if (shaderParams.ParticleColorGlobal)
		{
			V_ParticleColorEnd(_.particleColorMultiplier_vt_4, _.particleColorOffset_vt_4, _.particleColorMultiplier_v, _.particleColorOffset_v);
		}
	}
}

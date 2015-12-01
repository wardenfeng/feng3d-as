package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.fagal.params.ParticleShaderParams;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 粒子顶点渲染程序
	 * @author feng 2014-11-14
	 */
	public function V_Particles():void
	{
		var _:* = FagalRE.instance.space;

		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var particleShaderParams:ParticleShaderParams = shaderParams.getComponent(ParticleShaderParams.NAME);

		//初始化
		if (particleShaderParams.changePosition > 0)
		{
			V_ParticlesInit(_.particlePositionTemp_vt_4, _.animatedPosition_vt_4, _.position_va_3, _.particleCommon_vc_vector);
		}

		//粒子颜色初始化
		if (particleShaderParams.changeColor > 0)
		{
			V_ParticlesInitColor(_.particleCommon_vc_vector, _.particleColorMultiplier_vt_4, _.particleColorOffset_vt_4);
		}

		//计算时间
		if (particleShaderParams.ParticleTimeLocalStatic)
		{
			V_ParticlesTime(_.particleCommon_vc_vector, _.animatedPosition_vt_4, _.particleTime_va_4, _.particleTime_vc_vector, _.inCycleTime_vt_4);
		}

		//粒子速度节点顶点渲染程序
		if (particleShaderParams.ParticleVelocityGlobal)
		{
			V_ParticleVelocityGlobal(_.particleVelocity_vc_vector, _.particlePositionTemp_vt_4, _.inCycleTime_vt_4);
		}
		//计算速度
		if (particleShaderParams.ParticleVelocityLocalStatic)
		{
			V_ParticleVelocity(_.particleVelocity_va_3, _.particlePositionTemp_vt_4, _.inCycleTime_vt_4);
		}

		//粒子缩放节点顶点渲染程序
		if (particleShaderParams.ParticleScaleGlobal)
		{
			V_ParticleScaleGlobal(_.particleScale_vc_vector, _.inCycleTime_vt_4, _.animatedPosition_vt_4);
		}

		//使用广告牌 朝向摄像机
		if (particleShaderParams.ParticleBillboardGlobal)
		{
			V_ParticleBillboard(_.particleBillboard_vc_matrix, _.animatedPosition_vt_4);
		}

		//粒子颜色节点顶点渲染程序
		if (particleShaderParams.changeColor > 0)
		{
			V_ParticleColorGlobal(_.particleStartColorMultiplier_vc_vector, _.particleDeltaColorMultiplier_vc_vector, _.particleStartColorOffset_vc_vector, _.particleDeltaColorOffset_vc_vector, _.inCycleTime_vt_4, _.particleColorMultiplier_vt_4, _.particleColorOffset_vt_4);
		}

		//结算坐标偏移
		if (particleShaderParams.changePosition > 0)
		{
			V_ParticlePositionEnd(_.animatedPosition_vt_4, _.particlePositionTemp_vt_4);
		}

		//结算颜色
		if (particleShaderParams.ParticleColorGlobal)
		{
			V_ParticleColorEnd(_.particleColorMultiplier_vt_4, _.particleColorOffset_vt_4, _.particleColorMultiplier_v, _.particleColorOffset_v);
		}
	}
}

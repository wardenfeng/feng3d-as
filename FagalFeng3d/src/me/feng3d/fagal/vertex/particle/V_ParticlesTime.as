package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.operation.frc;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.base.operation.sge;
	import me.feng3d.fagal.base.operation.sub;

	/**
	 * 粒子时间节点顶点渲染程序
	 * @author warden_feng 2014-12-26
	 */
	public function V_ParticlesTime(particleCommon:Register, animatedPosition:Register, particleTimeVA:Register, particleTimeVC:Register, inCycleTimeTemp:Register):void
	{
		var vt3:Register = getFreeTemp();

		//计算时间
		sub(inCycleTimeTemp.x, particleTimeVC, particleTimeVA.x); //生存了的时间  = 粒子特效时间 - 粒子出生时间
		sge(vt3.x, inCycleTimeTemp.x, particleCommon.x); //粒子是否出生  = 生存了的时间 [inCycleTimeTemp.x] > 0[particleCommon.x] ? 1 : 0
		mul(animatedPosition.xyz, animatedPosition.xyz, vt3.x); //粒子顶点坐标 = 粒子顶点坐标 * 粒子是否出生

		//处理循环
		mul(vt3.x, inCycleTimeTemp.x, particleTimeVA.w); //粒子生存的周期数 = 生存了的时间 * 周期倒数
		frc(vt3.x, vt3.x); //本周期比例 = 粒子生存的周期数取小数部分
		mul(inCycleTimeTemp.x, vt3.x, particleTimeVA.y); //周期内时间 = 本周期比例 * 周期 

		//计算周期数(vt2.y)
		mul(inCycleTimeTemp.y, inCycleTimeTemp.x, particleTimeVA.w); //本周期比例 = 周期内时间 * 周期倒数
		
		removeTemp(vt3);
	}
}

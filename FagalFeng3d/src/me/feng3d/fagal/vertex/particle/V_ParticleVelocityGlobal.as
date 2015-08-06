package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 粒子速度节点顶点渲染程序
	 * @param particleVelocity			粒子速度数据
	 * @param positionTemp				偏移坐标临时寄存器
	 * @param inCycleTimeTemp			粒子周期内时间临时寄存器
	 * @author warden_feng 2014-12-26
	 */
	public function V_ParticleVelocityGlobal(particleVelocity:Register, positionTemp:Register, inCycleTimeTemp:Register):void
	{
		var _:* = FagalRE.instance.space;

		var vt3:Register = getFreeTemp();

		//计算速度
		_.mul(vt3, inCycleTimeTemp.x, particleVelocity); //时间*速度
		_.add(positionTemp.xyz, vt3, positionTemp.xyz); //计算偏移量
	}
}

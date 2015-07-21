package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.operation.add;

	/**
	 * 粒子结算偏移坐标渲染程序
	 * @param animatedPosition			动画后的顶点坐标数据
	 * @param positionTemp				偏移坐标临时寄存器
	 * @author warden_feng 2014-12-26
	 */
	public function V_ParticlePositionEnd(animatedPosition:Register, positionTemp:Register):void
	{
		//得到最终坐标
		add(animatedPosition.xyz, animatedPosition.xyz, positionTemp.xyz);
	}
}

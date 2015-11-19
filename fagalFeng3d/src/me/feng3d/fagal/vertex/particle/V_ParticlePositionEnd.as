package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 粒子结算偏移坐标渲染程序
	 * @param animatedPosition			动画后的顶点坐标数据
	 * @param positionTemp				偏移坐标临时寄存器
	 * @author feng 2014-12-26
	 */
	public function V_ParticlePositionEnd(animatedPosition:Register, positionTemp:Register):void
	{
		var _:* = FagalRE.instance.space;

		//得到最终坐标
		_.add(animatedPosition.xyz, animatedPosition.xyz, positionTemp.xyz);
	}
}

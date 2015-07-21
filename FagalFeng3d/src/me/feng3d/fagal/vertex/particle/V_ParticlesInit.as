package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.operation.mov;

	/**
	 * 粒子初始化顶点渲染程序
	 * @param positionTemp			偏移坐标临时寄存器
	 * @param animatedPosition		动画后的顶点坐标数据
	 * @param positionReg			顶点坐标数据
	 * @param particleCommon		粒子常数数据[0,1,2,0]
	 * @author warden_feng 2014-12-26
	 */
	public function V_ParticlesInit(positionTemp:Register, animatedPosition:Register, positionReg:Register, particleCommon:Register):void
	{
		comment("初始化粒子");
		mov(animatedPosition, positionReg); //坐标赋值
		mov(positionTemp.xyz, particleCommon.x); //初始化偏移位置0
	}
}

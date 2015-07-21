package me.feng3d.fagal.vertex.animation
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.operation.mov;

	/**
	 * 骨骼动画渲染程序(CPU)
	 * @param animatedPosition			动画后的顶点坐标数据
	 * @param animatedReg				骨骼动画计算完成后的顶点坐标数据
	 * @author warden_feng 2014-11-3
	 */
	public function V_SkeletonAnimationCPU(animatedPosition:Register, animatedReg:Register):Register
	{
		mov(animatedPosition, animatedReg);
		return animatedPosition;
	}
}

package me.feng3d.fagal.vertex.animation
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.operation.mov;

	/**
	 * 顶点动画渲染程序(CPU)
	 * @param animatedPosition			动画后的顶点坐标数据
	 * @param position					顶点坐标数据
	 * @author warden_feng 2014-11-3
	 */
	public function V_VertexAnimationCPU(animatedPosition:Register, position:Register):Register
	{
		mov(animatedPosition, position);

		return animatedPosition;
	}
}

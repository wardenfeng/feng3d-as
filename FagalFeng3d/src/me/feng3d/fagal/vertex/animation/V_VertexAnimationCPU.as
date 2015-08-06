package me.feng3d.fagal.vertex.animation
{
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 顶点动画渲染程序(CPU)
	 * @author warden_feng 2014-11-3
	 */
	public function V_VertexAnimationCPU():void
	{
		var _:* = FagalRE.instance.space;

		_.mov(_.animatedPosition_vt_4, _.position_va_3);
	}
}

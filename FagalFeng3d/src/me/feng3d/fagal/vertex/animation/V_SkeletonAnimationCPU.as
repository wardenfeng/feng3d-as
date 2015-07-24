package me.feng3d.fagal.vertex.animation
{
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagalRE.FagalRE;


	/**
	 * 骨骼动画渲染程序(CPU)
	 * @author warden_feng 2014-11-3
	 */
	public function V_SkeletonAnimationCPU():void
	{
		var _:* = FagalRE.instance.space;

		mov(_.animatedPosition_vt_4, _.animated_va_3);
	}
}

package me.feng3d.fagal.vertex.animation
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 顶点动画渲染程序(GPU)
	 * @author warden_feng 2014-11-3
	 */
	public function V_VertexAnimationGPU():void
	{
		var _:* = FagalRE.instance.space;

		//		
		var tempVts0:Register = getFreeTemp();
		var tempVts1:Register = getFreeTemp();

		//			comment("计算第0个顶点混合值");
		mul(tempVts0, _.position0_va_3, _.weights_vc_vector.x);
		//			comment("计算第1个顶点混合值");
		mul(tempVts1, _.position1_va_3, _.weights_vc_vector.y);
		//			comment("混合两个顶点");
		add(_.animatedPosition_vt_4, tempVts0, tempVts1);

		removeTemp(tempVts0);
		removeTemp(tempVts1);
	}
}

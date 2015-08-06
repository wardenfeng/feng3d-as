package me.feng3d.fagal.vertex.animation
{
	import me.feng3d.core.register.Register;
	
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 顶点动画渲染程序(GPU)
	 * @author warden_feng 2014-11-3
	 */
	public function V_VertexAnimationGPU():void
	{
		var _:* = FagalRE.instance.space;

		//		
		var tempVts0:Register = _.getFreeTemp();
		var tempVts1:Register = _.getFreeTemp();

		//			_.comment("计算第0个顶点混合值");
		_.mul(tempVts0, _.position0_va_3, _.weights_vc_vector.x);
		//			_.comment("计算第1个顶点混合值");
		_.mul(tempVts1, _.position1_va_3, _.weights_vc_vector.y);
		//			_.comment("混合两个顶点");
		_.add(_.animatedPosition_vt_4, tempVts0, tempVts1);
	}
}

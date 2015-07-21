package me.feng3d.fagal.vertex.animation
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 顶点动画渲染程序(GPU)
	 * @author warden_feng 2014-11-3
	 */
	public function V_VertexAnimationGPU():Register
	{
		var animatedPosition:Register = requestRegister(Context3DBufferTypeID.ANIMATEDPOSITION_VT_4);
		var p0:Register = requestRegister(Context3DBufferTypeID.POSITION0_VA_3);
		var p1:Register = requestRegister(Context3DBufferTypeID.POSITION1_VA_3);
		var weight:Register = requestRegister(Context3DBufferTypeID.WEIGHTS_VC_VECTOR);

		//		
		var tempVts0:Register = getFreeTemp();
		var tempVts1:Register = getFreeTemp();

		//			comment("计算第0个顶点混合值");
		mul(tempVts0, p0, weight.x);
		//			comment("计算第1个顶点混合值");
		mul(tempVts1, p1, weight.y);
		//			comment("混合两个顶点");
		add(animatedPosition, tempVts0, tempVts1);

		removeTemp(tempVts0);
		removeTemp(tempVts1);

		return animatedPosition;
	}
}

package me.feng3d.fagal.vertex.animation
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.mul;

	/**
	 * 顶点动画渲染程序(GPU)
	 * @param animatedPosition			动画后的顶点坐标数据
	 * @param p0						顶点动画第0个坐标数据
	 * @param p1						顶点动画第1个坐标数据
	 * @param weight					顶点程序权重向量静态数据
	 * @author warden_feng 2014-11-3
	 */
	public function V_VertexAnimationGPU(animatedPosition:Register, p0:Register, p1:Register, weight:Register):Register
	{
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

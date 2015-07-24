package me.feng3d.fagal.vertex.animation
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.operation.dp4;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 骨骼动画渲染程序(GPU)
	 * @author warden_feng 2014-11-3
	 */
	public function V_SkeletonAnimationGPU():Register
	{
		var _:* = FagalRE.instance.space;

		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;

		//
		var vt1:Register = getFreeTemp();
		var vt2:Register = getFreeTemp();

		comment("计算该顶点坐标通关该关节得到的x值-----------1");
		dp4(vt1.x, _.position_va_3, _.globalmatrices_vc_vector.getReg1(_.jointindex_va_x.x));
		comment("计算该顶点坐标通关该关节得到的y值-----------2");
		dp4(vt1.y, _.position_va_3, _.globalmatrices_vc_vector.getReg1(_.jointindex_va_x.x, 1));
		comment("计算该顶点坐标通关该关节得到的z值-----------3");
		dp4(vt1.z, _.position_va_3, _.globalmatrices_vc_vector.getReg1(_.jointindex_va_x.x, 2));
		comment("w值不变-----------------4");
		mov(vt1.w, _.position_va_3.w);
		comment("通过权重计算该关节对顶点的影响值---------------5");
		mul(vt1, vt1, _.jointweights_va_x.x);
		comment("vt2保存了计算后的顶点坐标，第一个关节影响值使用mov赋值，后面的关节将会使用add来累加-----------------6(1到6将会对每个与该顶点相关的关节调用，该实例中只有一个关节，所以少了个for循环)");
		mov(vt2, vt1);
		comment("赋值给顶点坐标寄存器，提供给后面投影使用");
		mov(_.animatedPosition_vt_4, vt2);

		removeTemp(vt1);
		removeTemp(vt2);

		return _.animatedPosition_vt_4;
	}

}

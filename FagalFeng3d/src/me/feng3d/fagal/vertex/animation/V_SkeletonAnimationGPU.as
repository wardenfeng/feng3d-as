package me.feng3d.fagal.vertex.animation
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterVector;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.requestRegisterVector;
	import me.feng3d.fagal.base.operation.dp4;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.methods.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsAnimation;

	/**
	 * 骨骼动画渲染程序(GPU)
	 * @param animatedPosition			动画后的顶点坐标数据
	 * @author warden_feng 2014-11-3
	 */
	public function V_SkeletonAnimationGPU(animatedPosition:Register):Register
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var shaderParamsAnimation:ShaderParamsAnimation = shaderParams.getComponent(ShaderParamsAnimation.NAME);

		//顶点坐标数据
		var positionReg:Register = requestRegister(Context3DBufferTypeID.POSITION_VA_3);
		//关节索引数据寄存器
		var jointindexReg:Register = requestRegister(Context3DBufferTypeID.JOINTINDEX_VA_X);
		//关节权重数据寄存器
		var JointWeightsReg:Register = requestRegister(Context3DBufferTypeID.JOINTWEIGHTS_VA_X);
		//骨骼全局变换矩阵静态数据
		var globalmatricesReg:RegisterVector = requestRegisterVector(Context3DBufferTypeID.GLOBALMATRICES_VC_VECTOR, shaderParamsAnimation.numJoints * 3);

		//
		var vt1:Register = getFreeTemp();
		var vt2:Register = getFreeTemp();

		comment("计算该顶点坐标通关该关节得到的x值-----------1");
		dp4(vt1.x, positionReg, globalmatricesReg.getReg1(jointindexReg.x));
		comment("计算该顶点坐标通关该关节得到的y值-----------2");
		dp4(vt1.y, positionReg, globalmatricesReg.getReg1(jointindexReg.x, 1));
		comment("计算该顶点坐标通关该关节得到的z值-----------3");
		dp4(vt1.z, positionReg, globalmatricesReg.getReg1(jointindexReg.x, 2));
		comment("w值不变-----------------4");
		mov(vt1.w, positionReg.w);
		comment("通过权重计算该关节对顶点的影响值---------------5");
		mul(vt1, vt1, JointWeightsReg.x);
		comment("vt2保存了计算后的顶点坐标，第一个关节影响值使用mov赋值，后面的关节将会使用add来累加-----------------6(1到6将会对每个与该顶点相关的关节调用，该实例中只有一个关节，所以少了个for循环)");
		mov(vt2, vt1);
		comment("赋值给顶点坐标寄存器，提供给后面投影使用");
		mov(animatedPosition, vt2);

		removeTemp(vt1);
		removeTemp(vt2);

		return animatedPosition;
	}

}

package me.feng3d.fagal.fragment.shadowMap
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.math.blend;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.dp4;
	import me.feng3d.fagal.base.operation.frc;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.base.operation.slt;
	import me.feng3d.fagal.base.operation.tex;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 阴影图采样比较计算阴影值
	 * @author warden_feng 2015-7-17
	 */
	public function F_ShadowMapSample():void
	{
		var targetReg:Register = requestRegister(Context3DBufferTypeID.SHADOWVALUE_FT_4);

		var depthMapRegister:Register = requestRegister(Context3DBufferTypeID.DEPTHMAP_FS);
		var decReg:Register = requestRegister(Context3DBufferTypeID.SHADOWCOMMONDATA0_FC_VECTOR);
		var customDataReg:Register = requestRegister(Context3DBufferTypeID.SHADOWCOMMONDATA2_FC_VECTOR);
		var depthCol:Register = getFreeTemp("深度值临时寄存器");
		var uvReg:Register = getFreeTemp("深度图uv临时寄存器");
		var _depthMapCoordReg:Register = requestRegister(Context3DBufferTypeID.DEPTHMAPCOORD_V);

		mov(uvReg, _depthMapCoordReg); //计算阴影

		tex(depthCol, _depthMapCoordReg, depthMapRegister); //读取阴影图值
		dp4(depthCol.z, depthCol, decReg);
		slt(uvReg.z, _depthMapCoordReg.z, depthCol.z); //比较深度 // 0 if in shadow

		add(uvReg.x, _depthMapCoordReg.x, customDataReg.z); //取(1,0)位置的深度值
		tex(depthCol, uvReg, depthMapRegister); //读取阴影图值
		dp4(depthCol.z, depthCol, decReg);
		slt(uvReg.w, _depthMapCoordReg.z, depthCol.z); //与(1,0)深度做比较 // 0 if in shadow

		mul(depthCol.x, _depthMapCoordReg.x, customDataReg.y); //计算顶点在阴影图的像素x位置
		frc(depthCol.x, depthCol.x); //取出分数部分  0<分数部分<1
		blend(targetReg.w, uvReg.z, uvReg.w, depthCol.x); //混合(0,0)与(1,0)的深度结果

		//与(0,1)深度做比较
		mov(uvReg.x, _depthMapCoordReg.x);
		add(uvReg.y, _depthMapCoordReg.y, customDataReg.z); // (0, 1)
		tex(depthCol, uvReg, depthMapRegister);
		dp4(depthCol.z, depthCol, decReg);
		slt(uvReg.z, _depthMapCoordReg.z, depthCol.z); // 0 if in shadow

		//与(1,1)深度做比较
		add(uvReg.x, _depthMapCoordReg.x, customDataReg.z); // (1, 1)
		tex(depthCol, uvReg, depthMapRegister);
		dp4(depthCol.z, depthCol, decReg);
		slt(uvReg.w, _depthMapCoordReg.z, depthCol.z); // 0 if in shadow

		//根据X方向分数部分来混合(0,1)与(1,1)的深度结果  x1-x0
		mul(depthCol.x, _depthMapCoordReg.x, customDataReg.y);
		frc(depthCol.x, depthCol.x);
		blend(uvReg.w, uvReg.z, uvReg.w, depthCol.x);

		//再次根据Y方向分数部分来混合两次X方向混合的结果
		mul(depthCol.x, _depthMapCoordReg.y, customDataReg.y);
		frc(depthCol.x, depthCol.x);
		blend(targetReg.w, targetReg.w, uvReg.w, depthCol.x);

		removeTemp(depthCol);
		removeTemp(uvReg);
	}
}

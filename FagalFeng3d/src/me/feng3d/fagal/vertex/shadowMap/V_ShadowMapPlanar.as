package me.feng3d.fagal.vertex.shadowMap
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterMatrix;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.requestRegisterMatrix;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.div;
	import me.feng3d.fagal.base.operation.m44;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 方向光阴影映射
	 * @author warden_feng 2015-7-17
	 */
	public function V_ShadowMapPlanar():void
	{
		var temp:Register = getFreeTemp();
		var dataReg:Register = requestRegister(Context3DBufferTypeID.SHADOWCOMMONDATA0_VC_VECTOR);
		var depthMapProj:RegisterMatrix = requestRegisterMatrix(Context3DBufferTypeID.DEPTHMAP_VC_MATRIX);
		var _depthMapCoordReg:Register = requestRegister(Context3DBufferTypeID.DEPTHMAPCOORD_V);

		//顶点世界坐标
		var globalPositionVertex:Register = requestRegister(Context3DBufferTypeID.GLOBALPOSITION_VT_4);

		//计算顶点深度值
		m44(temp, globalPositionVertex, depthMapProj);
		//计算顶点深度值(x,y计算深度图中的uv，z计算深度)
		div(temp, temp, temp.w);
		//x,y计算深度图中的uv
		mul(temp.xy, temp.xy, dataReg.xy);
		//计算深度图坐标
		add(_depthMapCoordReg, temp, dataReg.xxwz);
	}
}

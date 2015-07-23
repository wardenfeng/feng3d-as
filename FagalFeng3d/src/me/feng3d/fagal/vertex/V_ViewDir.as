package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.sub;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 视线顶点渲染函数
	 * @author warden_feng 2014-11-7
	 */
	public function V_ViewDir():void
	{
		//顶点世界坐标
		var globalPositionReg:Register = requestRegister(Context3DBufferTypeID.globalPosition_vt_4);
		//视线变量寄存器
		var viewDirVaryingReg:Register = requestRegister(Context3DBufferTypeID.viewDir_v);
		//摄像机世界坐标
		var cameraPositionReg:Register = requestRegister(Context3DBufferTypeID.cameraPosition_vc_vector);

		comment("计算视线方向");
		sub(viewDirVaryingReg, cameraPositionReg, globalPositionReg);

	}
}

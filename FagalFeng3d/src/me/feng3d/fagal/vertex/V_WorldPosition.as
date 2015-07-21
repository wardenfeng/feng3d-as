package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterMatrix;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.requestRegisterMatrix;
	import me.feng3d.fagal.base.operation.m44;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;

	/**
	 * 顶点世界坐标渲染函数
	 * @author warden_feng 2014-11-7
	 */
	public function V_WorldPosition():void
	{
		//顶点坐标数据
		var localPositionReg:Register = requestRegister(Context3DBufferTypeID.POSITION_VA_3);
		//顶点世界坐标
		var positionSceneReg:Register = requestRegister(Context3DBufferTypeID.GLOBALPOSITION_VT_4);
		//场景变换矩阵(模型空间转世界空间)
		var sceneTransformMatrixReg:RegisterMatrix = requestRegisterMatrix(Context3DBufferTypeID.SCENETRANSFORM_VC_MATRIX);

		comment("场景坐标转换");
		m44(positionSceneReg, localPositionReg, sceneTransformMatrixReg);
	}
}

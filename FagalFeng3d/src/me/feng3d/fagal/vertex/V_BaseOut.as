package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterMatrix;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.requestRegisterMatrix;
	import me.feng3d.fagal.base.operation.m44;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;

	/**
	 * 基本顶点投影渲染
	 * @author warden_feng 2014-10-30
	 */
	public function V_BaseOut():void
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;

		//动画后的顶点坐标数据
		var animatedPosition:Register = requestRegister(Context3DBufferTypeID.animatedPosition_vt_4);
		//顶点程序投影矩阵静态数据
		var projection:RegisterMatrix = requestRegisterMatrix(Context3DBufferTypeID.projection_vc_matrix);
		//位置输出寄存器
		var op:Register = requestRegister(Context3DBufferTypeID._op);

		//阴影渲染需要 投影后的顶点坐标
		if (shaderParams.needsProjection > 0)
		{
			var projectionFragment:Register = requestRegister(Context3DBufferTypeID.positionProjected_v);

			var vt5:Register = getFreeTemp("投影后顶点坐标");
			m44(vt5, animatedPosition, projection);
			//保存投影坐标数据
			mov(projectionFragment, vt5);
			mov(op, vt5);
		}
		else
		{
			m44(op, animatedPosition, projection);
		}
	}
}

package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.operation.sub;

	/**
	 * 视线顶点渲染函数
	 * @param globalPositionReg			顶点世界坐标
	 * @param viewDirVaryingReg			视线变量寄存器
	 * @param cameraPositionReg			摄像机世界坐标
	 * @author warden_feng 2014-11-7
	 */
	public function V_ViewDir(globalPositionReg:Register, viewDirVaryingReg:Register, cameraPositionReg:Register):void
	{
		comment("计算视线方向");
		sub(viewDirVaryingReg, cameraPositionReg, globalPositionReg);

	}
}

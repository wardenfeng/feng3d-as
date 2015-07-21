package me.feng3d.fagal.vertex.shadowMap
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterMatrix;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.requestRegisterMatrix;
	import me.feng3d.fagal.base.operation.m44;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDAnimation;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDCommon;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDShadow;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 深度图顶点主程序
	 * @author warden_feng 2015-5-30
	 */
	public class V_Main_DepthMap extends FagalMethod
	{
		/**
		 * 构建 深度图顶点主程序
		 */
		public function V_Main_DepthMap()
		{
			_shaderType = Context3DProgramType.VERTEX;
		}

		/**
		 * @inheritDoc
		 */
		override public function runFunc():void
		{
			var position:Register = requestRegister(Context3DBufferTypeIDCommon.POSITION_VA_3);
			var animatedPosition:Register = requestRegister(Context3DBufferTypeIDAnimation.ANIMATEDPOSITION_VT_4);
			//顶点程序投影矩阵静态数据
			var projection:RegisterMatrix = requestRegisterMatrix(Context3DBufferTypeIDCommon.PROJECTION_VC_MATRIX);
			//位置输出寄存器
			var out:Register = requestRegister(Context3DBufferTypeIDCommon.OP);
			//投影后的顶点坐标 变量数据
			var positionProjectedVarying:Register = requestRegister(Context3DBufferTypeIDShadow.POSITIONPROJECTED_V);

			//普通动画
			mov(animatedPosition, position);
			var outPosition:Register = getFreeTemp("投影后的坐标");
			//计算投影
			m44(outPosition, animatedPosition, projection);
			//输出顶点坐标数据			
			mov(out, outPosition);
			//把顶点投影坐标输出到片段着色器
			mov(positionProjectedVarying, outPosition);
		}
	}
}

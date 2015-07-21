package me.feng3d.fagal.context3dDataIds
{

	/**
	 * 动画相关寄存器数据类型
	 * @author warden_feng 2015-5-5
	 */
	public class Context3DBufferTypeIDAnimation
	{
		/** 骨骼动画计算完成后的顶点坐标数据 */
		public static const ANIMATED_VA_3:String = "animated_va_3";

		/** 顶点动画第0个坐标数据 */
		public static const POSITION0_VA_3:String = "position0_va_3";

		/** 顶点动画第1个坐标数据 */
		public static const POSITION1_VA_3:String = "position1_va_3";

		/** 动画后的顶点坐标数据 */
		public static const ANIMATEDPOSITION_VT_4:String = "animatedPosition_vt_4";

		/** 关节索引数据 */
		public static const JOINTINDEX_VA_X:String = "jointindex_va_x";

		/** 关节权重数据 */
		public static const JOINTWEIGHTS_VA_X:String = "jointweights_va_x";


		/** 顶点程序权重向量静态数据 */
		public static const WEIGHTS_VC_VECTOR:String = "weights_vc_vector";

		/** 骨骼全局变换矩阵静态数据 */
		public static const GLOBALMATRICES_VC_VECTOR:String = "globalmatrices_vc_vector";
	}
}

package me.feng3d.fagal.context3dDataIds
{

	/**
	 * 寄存器数据类型
	 * @author warden_feng 2015-5-4
	 */
	public class Context3DBufferTypeIDCommon
	{
		/** 索引数据 */
		public static const INDEX:String = "index";

		/** 顶点坐标数据 */
		public static const POSITION_VA_3:String = "position_va_3";

		/** 顶点颜色数据 */
		public static const COLOR_VA_3:String = "color_va_3";

		/** uv数据 */
		public static const UV_VA_2:String = "uv_va_2";

		/** 顶点程序投影矩阵静态数据 */
		public static const PROJECTION_VC_MATRIX:String = "projection_vc_matrix";

		/** uv变量数据 */
		public static const UV_V:String = "uv_v";

		/** 片段程序的纹理 */
		public static const TEXTURE_FS:String = "texture_fs";

		/** 颜色静态数据 */
		public static const COLOR_FC_VECTOR:String = "color_fc_vector";

		/** 渲染程序 */
		public static const PROGRAM:String = "program";

		/** 三角形剔除模式 */
		public static const CULLING:String = "culling";

		/** 颜色混合 */
		public static const BLEND_FACTORS:String = "blendFactors";

		/** 深度测试模式 */
		public static const DEPTH_TEST:String = "depthTest";

		/** 公用数据片段常量数据 */
		public static const COMMONSDATA_FC_VECTOR:String = "commonsData_fc_vector";

		/** 顶点输出寄存器 */
		public static const OP:String = "_op";
		/** 片段输出寄存器 */
		public static const OC:String = "_oc";
	}
}

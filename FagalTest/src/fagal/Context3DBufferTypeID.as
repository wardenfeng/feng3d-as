package fagal
{

	/**
	 * 寄存器数据类型
	 * @author warden_feng 2014-6-9
	 */
	public class Context3DBufferTypeID
	{
		/** 索引数据 */
		public static const index:String = "index";

		/** 渲染程序 */
		public static const PROGRAM:String = "program";

		/** 顶点坐标数据 */
		public static const POSITION_VA_3:String = "position_va_3";

		/** 顶点颜色数据 */
		public static const COLOR_VA_3:String = "color_va_3";

		/** 顶点程序投影矩阵静态数据 */
		public static const PROJECTION_VC_MATRIX:String = "projection_vc_matrix";

		/** 颜色变量寄存器 */
		public static const COLOR_V:String = "color_v";

		/** 顶点输出寄存器 */
		public static const OP:String = "_op";

		/** 片段输出寄存器 */
		public static const OC:String = "_oc";

		//------------------------
		//		地形渲染相关
		//------------------------
		/** 地形纹理数组 */
		public static const TERRAINTEXTURES_FS_ARRAY:String = "terrainTextures_fs_array";

		/** uv数据 */
		public static const UV_VA_2:String = "uv_va_2";

		/** uv变量数据 */
		public static const UV_V:String = "uv_v";

		//------------------------
		//		地形渲染相关
		//------------------------
		/** 公用数据片段常量数据 */
		public static const COMMONSDATA_VC_VECTOR:String = "commonsData_vc_vector";

	}
}


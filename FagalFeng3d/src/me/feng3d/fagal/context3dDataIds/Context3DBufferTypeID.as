package me.feng3d.fagal.context3dDataIds
{

	/**
	 * 寄存器数据类型
	 * @author warden_feng 2014-6-9
	 */
	public class Context3DBufferTypeID
	{
		/** 法线数据 */
		public static const NORMAL_VA_3:String = "normal_va_3";

		/** 切线数据 */
		public static const TANGENT_VA_3:String = "tangent_va_3";

		/** 摄像机位置静态数据 */
		public static const CAMERAPOS_VC_VECTOR:String = "camerapos_vc_vector";

		/** 场景变换矩阵(模型空间转场景空间) */
		public static const SCENETRANSFORM_VC_MATRIX:String = "sceneTransform_vc_matrix";

		/** 法线场景变换矩阵(模型空间转场景空间) */
		public static const NORMALSCENETRANSFORM_VC_MATRIX:String = "normalSceneTransform_vc_matrix";

		/** 世界投影矩阵(世界坐标转context3D的2D坐标) */
		public static const WORDPROJECTION_VC_MATRIX:String = "wordProjection_vc_matrix";

		/** 法线临时片段寄存器 */
		public static const NORMAL_FT_4:String = "normal_ft_4";

		/** 顶点世界坐标 */
		public static const GLOBALPOSITION_VT_4:String = "globalPosition_vt_4";

		/** 摄像机世界坐标 */
		public static const CAMERAPOSITION_VC_VECTOR:String = "cameraposition_vc_vector";

		/** 法线变量寄存器 */
		public static const NORMAL_V:String = "normal_v";

		/** 切线变量寄存器 */
		public static const TANGENT_V:String = "tangent_v";

		/** 双切线变量寄存器 */
		public static const BITANGENT_V:String = "bitangent_v";

		/** 视线变量寄存器 */
		public static const VIEWDIR_V:String = "viewDir_v";


		/** 世界坐标变量 */
		public static const GLOBALPOS_V:String = "globalPos_v";

		/** 视线方向片段临时数据 */
		public static const VIEWDIR_FT_4:String = "viewDir_ft_4";

		/** 切线片段临时寄存器 */
		public static const TANGENT_FT_4:String = "tangent_ft_4";

		/** 双切线片段临时寄存器 */
		public static const BITANGENT_FT_4:String = "biTangent_ft_4";

		/** 法线纹理寄存器 */
		public static const NORMALTEXTURE_FS:String = "normalTexture_fs";

		/** 最终颜色寄存器（输出到oc寄存器的颜色） */
		public static const FINALCOLOR_FT_4:String = "finalColor_ft_4";
	}
}

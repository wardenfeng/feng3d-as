package me.feng3d.fagal.context3dDataIds
{

	/**
	 * 阴影相关寄存器数据类型
	 * @author warden_feng 2015-5-28
	 */
	public class Context3DBufferTypeIDShadow
	{
		/** 深度映射纹理(该纹理由片段着色器输出) */
		public static const DEPTHMAP_OC:String = "depthMap_oc";

		/** 深度映射纹理 */
		public static const DEPTHMAP_FS:String = "depthMap_fs";

		/** 深度映射矩阵 */
		public static const DEPTHMAP_VC_MATRIX:String = "depthMap_vc_matrix";

		/** 深度顶点常数0 (1.0, 255.0, 65025.0, 16581375.0) */
		public static const DEPTHCOMMONDATA0_FC_VECTOR:String = "depthCommonData0_fc_vector";

		/** 深度顶点常数1 (1.0/255.0, 1.0/255.0, 1.0/255.0, 0.0) */
		public static const DEPTHCOMMONDATA1_FC_VECTOR:String = "depthCommonData1_fc_vector";

		/** 投影后的顶点坐标 变量数据 */
		public static const POSITIONPROJECTED_V:String = "positionProjected_v";

		/** 深度映射uv坐标 变量数据 */
		public static const DEPTHMAPCOORD_V:String = "depthMapCoord_v";

		/** 阴影函数顶点常数0 (0.5,-0.5,0,1) 用于深度值转换为uv值 */
		public static const SHADOWCOMMONDATA0_VC_VECTOR:String = "shadowCommondata0_vc_vector";

		/** 阴影函数片段常数0 (1.0,1.0/255,1.0/255/255,1.0/255/255/255) 用于颜色值转换为深度值 */
		public static const SHADOWCOMMONDATA0_FC_VECTOR:String = "shadowCommondata0_fc_vector";

		/** 阴影函数片段常数1 */
		public static const SHADOWCOMMONDATA1_FC_VECTOR:String = "shadowCommondata1_fc_vector";

		/** 阴影函数片段常数2 保存有深度图尺寸 */
		public static const SHADOWCOMMONDATA2_FC_VECTOR:String = "shadowCommondata2_fc_vector";

		/** 用于计算阴影相对于观察者距离不同而作衰减 */
		public static const SECONDARY_FC_VECTOR:String = "secondary_fc_vector";

		/** 阴影值临时变量寄存器 */
		public static const SHADOWVALUE_FT_4:String = "shadowValue_ft_4";
	}
}

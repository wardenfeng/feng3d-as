package me.feng3d.fagal.context3dDataIds
{

	/**
	 * 灯光相关寄存器数据类型
	 * @author warden_feng 2015-5-5
	 */
	public class Context3DBufferTypeIDLight
	{
		/** 环境输入静态数据 */
		public static const AMBIENTINPUT_FC_VECTOR:String = "ambientInput_fc_vector";

		/** 漫射输入静态数据 */
		public static const DIFFUSEINPUT_FC_VECTOR:String = "diffuseInput_fc_vector";

		/** 方向光源场景方向 */
		public static const DIRLIGHTSCENEDIR_FC_VECTOR:String = "dirLightSceneDir_fc_vector";

		/** 方向光源漫反射光颜色 */
		public static const DIRLIGHTDIFFUSE_FC_VECTOR:String = "dirLightDiffuse_fc_vector";

		/** 方向光源镜面反射颜色 */
		public static const DIRLIGHTSPECULAR_FC_VECTOR:String = "dirLightSpecular_fc_vector";

		/** 点光源场景位置 */
		public static const POINTLIGHTSCENEPOS_FC_VECTOR:String = "pointLightScenePos_fc_vector";

		/** 点光源漫反射光颜色 */
		public static const POINTLIGHTDIFFUSE_FC_VECTOR:String = "pointLightDiffuse_fc_vector";

		/** 点光源镜面反射颜色 */
		public static const POINTLIGHTSPECULAR_FC_VECTOR:String = "pointLightSpecular_fc_vector";

		/** 材质镜面反射光数据 */
		public static const SPECULARDATA_FC_VECTOR:String = "specularData_fc_vector";

		/** 镜面反射光临时片段寄存器 */
		public static const SPECULARCOLOR_FT_4:String = "specularColor_ft_4";

		/** 材质的漫反射颜色 */
		public static const MDIFF_FT:String = "Mdiff_ft";

		/** 环境光因子临时变量 */
		public static const AMBIENT_FT:String = "ambient_ft";

		/** 总漫反射颜色寄存器 */
		public static const TOTALDIFFUSELIGHTCOLOR_FT_4:String = "totalDiffuseLightColor_ft_4";

		/** 总镜面反射颜色寄存器 */
		public static const TOTALSPECULARLIGHTCOLOR_FT_4:String = "totalSpecularLightColor_ft_4";

		/** 光泽纹理寄存器 */
		public static const SPECULARTEXTURE_FS:String = "specularTexture_fs";
	}
}

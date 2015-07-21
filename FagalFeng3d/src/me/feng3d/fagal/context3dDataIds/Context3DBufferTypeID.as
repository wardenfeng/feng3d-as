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

		/** 天空盒缩放静态数据 */
		public static const SCALESKYBOX_VC_VECTOR:String = "scaleSkybox_vc_vector";

		/** 混合纹理 */
		public static const BLENDINGTEXTURE_FS:String = "blendingtexture_fs";

		/** 地形纹理数组 */
		public static const TERRAINTEXTURES_FS_ARRAY:String = "terrainTextures_fs_array";

		/** 地形常量 */
		public static const TILE_FC_VECTOR:String = "tile_fc_vector";

		/** 粒子常数数据[0,1,2,0] */
		public static const PARTICLECOMMON_VC_VECTOR:String = "particleCommon_vc_vector";

		/** 广告牌旋转矩阵 */
		public static const PARTICLEBILLBOARD_VC_MATRIX:String = "particleBillboard_vc_matrix";

		//--------------------------------
		//		缩放节点
		//--------------------------------
		/** 粒子缩放常数数据 */
		public static const PARTICLESCALE_VC_VECTOR:String = "particleScale_vc_vector";

		//--------------------------------
		//		时间节点
		//--------------------------------
		/** 粒子时间数据 */
		public static const PARTICLETIME_VA_4:String = "particleTime_va_4";

		/** 粒子时间常量数据 */
		public static const PARTICLETIME_VC_VECTOR:String = "particleTime_vc_vector";

		//--------------------------------
		//		速度节点
		//--------------------------------
		/** 粒子速度数据 */
		public static const PARTICLEVELOCITY_VA_3:String = "particleVelocity_va_3";

		/** 粒子速度常数数据 */
		public static const PARTICLEVELOCITY_VC_VECTOR:String = "particleVelocity_vc_vector";

		//--------------------------------
		//		颜色节点
		//--------------------------------
		/** 粒子颜色乘数因子起始值，用于计算粒子颜色乘数因子 */
		public static const PARTICLESTARTCOLORMULTIPLIER_VC_VECTOR:String = "particleStartColorMultiplier_vc_vector";

		/** 粒子颜色乘数因子增量值，用于计算粒子颜色乘数因子 */
		public static const PARTICLEDELTACOLORMULTIPLIER_VC_VECTOR:String = "particleDeltaColorMultiplier_vc_vector";

		/** 粒子颜色偏移起始值，用于计算粒子颜色偏移值 */
		public static const PARTICLESTARTCOLOROFFSET_VC_VECTOR:String = "particleStartColorOffset_vc_vector";

		/** 粒子颜色偏移增量值，用于计算粒子颜色偏移值 */
		public static const PARTICLEDELTACOLOROFFSET_VC_VECTOR:String = "particleDeltaColorOffset_vc_vector";

		/** 粒子颜色乘数因子，用于乘以纹理上的颜色值 */
		public static const PARTICLECOLORMULTIPLIER_V:String = "particleColorMultiplier_v";

		/** 粒子颜色乘数因子，用于乘以纹理上的颜色值 */
		public static const PARTICLECOLOROFFSET_V:String = "particleColorOffset_v";

		/** 线段起点坐标数据 */
		public static const SEGMENTSTART_VA_3:String = "segmentStart_va_3";

		/** 线段终点坐标数据 */
		public static const SEGMENTEND_VA_3:String = "segmentEnd_va_3";

		/** 线段厚度数据 */
		public static const SEGMENTTHICKNESS_VA_1:String = "segmentThickness_va_1";

		/** 线段颜色数据 */
		public static const SEGMENTCOLOR_VA_4:String = "segmentColor_va_4";

		/** 摄像机坐标系到投影坐标系变换矩阵静态数据 */
		public static const SEGMENTC2PMATRIX_VC_MATRIX:String = "segmentC2pMatrix_vc_matrix";

		/** 模型坐标系到摄像机坐标系变换矩阵静态数据 */
		public static const SEGMENTM2CMATRIX_VC_MATRIX:String = "segmentM2cMatrix_vc_matrix";

		/** 常数1 */
		public static const SEGMENTONE_VC_VECTOR:String = "segmentOne_vc_vector";
		/** 常数前向量 */
		public static const SEGMENTFRONT_VC_VECTOR:String = "segmentFront_vc_vector";
		/** 常量数据 */
		public static const SEGMENTCONSTANTS_VC_VECTOR:String = "segmentConstants_vc_vector";
	}
}

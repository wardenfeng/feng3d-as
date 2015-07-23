package me.feng3d.fagal.context3dDataIds
{

	/**
	 * 寄存器数据类型
	 * @author warden_feng 2014-6-9
	 */
	public class Context3DBufferTypeID
	{
		/** 法线数据 */
		public static const normal_va_3:String = "normal_va_3";

		/** 切线数据 */
		public static const tangent_va_3:String = "tangent_va_3";

		/** 摄像机位置静态数据 */
		public static const camerapos_vc_vector:String = "camerapos_vc_vector";

		/** 场景变换矩阵(模型空间转场景空间) */
		public static const sceneTransform_vc_matrix:String = "sceneTransform_vc_matrix";

		/** 法线场景变换矩阵(模型空间转场景空间) */
		public static const normalSceneTransform_vc_matrix:String = "normalSceneTransform_vc_matrix";

		/** 世界投影矩阵(世界坐标转context3D的2D坐标) */
		public static const wordProjection_vc_matrix:String = "wordProjection_vc_matrix";

		/** 法线临时片段寄存器 */
		public static const normal_ft_4:String = "normal_ft_4";

		/** 顶点世界坐标 */
		public static const globalPosition_vt_4:String = "globalPosition_vt_4";

		/** 摄像机世界坐标 */
		public static const cameraPosition_vc_vector:String = "cameraPosition_vc_vector";

		/** 法线变量寄存器 */
		public static const normal_v:String = "normal_v";

		/** 切线变量寄存器 */
		public static const tangent_v:String = "tangent_v";

		/** 双切线变量寄存器 */
		public static const bitangent_v:String = "bitangent_v";

		/** 视线变量寄存器 */
		public static const viewDir_v:String = "viewDir_v";


		/** 世界坐标变量 */
		public static const globalPos_v:String = "globalPos_v";

		/** 视线方向片段临时数据 */
		public static const viewDir_ft_4:String = "viewDir_ft_4";

		/** 切线片段临时寄存器 */
		public static const tangent_ft_4:String = "tangent_ft_4";

		/** 双切线片段临时寄存器 */
		public static const biTangent_ft_4:String = "biTangent_ft_4";

		/** 法线纹理寄存器 */
		public static const normalTexture_fs:String = "normalTexture_fs";

		/** 最终颜色寄存器（输出到oc寄存器的颜色） */
		public static const finalColor_ft_4:String = "finalColor_ft_4";

		/** 骨骼动画计算完成后的顶点坐标数据 */
		public static const animated_va_3:String = "animated_va_3";

		/** 顶点动画第0个坐标数据 */
		public static const position0_va_3:String = "position0_va_3";

		/** 顶点动画第1个坐标数据 */
		public static const position1_va_3:String = "position1_va_3";

		/** 动画后的顶点坐标数据 */
		public static const animatedPosition_vt_4:String = "animatedPosition_vt_4";

		/** 关节索引数据 */
		public static const jointindex_va_x:String = "jointindex_va_x";

		/** 关节权重数据 */
		public static const jointweights_va_x:String = "jointweights_va_x";


		/** 顶点程序权重向量静态数据 */
		public static const weights_vc_vector:String = "weights_vc_vector";

		/** 骨骼全局变换矩阵静态数据 */
		public static const globalmatrices_vc_vector:String = "globalmatrices_vc_vector";

		/** 索引数据 */
		public static const index:String = "index";

		/** 顶点坐标数据 */
		public static const position_va_3:String = "position_va_3";

		/** 顶点颜色数据 */
		public static const color_va_3:String = "color_va_3";

		/** uv数据 */
		public static const uv_va_2:String = "uv_va_2";

		/** 顶点程序投影矩阵静态数据 */
		public static const projection_vc_matrix:String = "projection_vc_matrix";

		/** uv变量数据 */
		public static const uv_v:String = "uv_v";

		/** 片段程序的纹理 */
		public static const texture_fs:String = "texture_fs";

		/** 颜色静态数据 */
		public static const color_fc_vector:String = "color_fc_vector";

		/** 渲染程序 */
		public static const program:String = "program";

		/** 三角形剔除模式 */
		public static const culling:String = "culling";

		/** 颜色混合 */
		public static const blendFactors:String = "blendFactors";

		/** 深度测试模式 */
		public static const depthTest:String = "depthTest";

		/** 公用数据片段常量数据 */
		public static const commonsData_fc_vector:String = "commonsData_fc_vector";

		/** 顶点输出寄存器 */
		public static const _op:String = "_op";
		/** 片段输出寄存器 */
		public static const _oc:String = "_oc";

		/** 环境输入静态数据 */
		public static const ambientInput_fc_vector:String = "ambientInput_fc_vector";

		/** 漫射输入静态数据 */
		public static const diffuseInput_fc_vector:String = "diffuseInput_fc_vector";

		/** 方向光源场景方向 */
		public static const dirLightSceneDir_fc_vector:String = "dirLightSceneDir_fc_vector";

		/** 方向光源漫反射光颜色 */
		public static const dirLightDiffuse_fc_vector:String = "dirLightDiffuse_fc_vector";

		/** 方向光源镜面反射颜色 */
		public static const dirLightSpecular_fc_vector:String = "dirLightSpecular_fc_vector";

		/** 点光源场景位置 */
		public static const pointLightScenePos_fc_vector:String = "pointLightScenePos_fc_vector";

		/** 点光源漫反射光颜色 */
		public static const pointLightDiffuse_fc_vector:String = "pointLightDiffuse_fc_vector";

		/** 点光源镜面反射颜色 */
		public static const pointLightSpecular_fc_vector:String = "pointLightSpecular_fc_vector";

		/** 材质镜面反射光数据 */
		public static const specularData_fc_vector:String = "specularData_fc_vector";

		/** 镜面反射光临时片段寄存器 */
		public static const specularColor_ft_4:String = "specularColor_ft_4";

		/** 材质的漫反射颜色 */
		public static const mDiff_ft:String = "mDiff_ft";

		/** 环境光因子临时变量 */
		public static const ambient_ft:String = "ambient_ft";

		/** 总漫反射颜色寄存器 */
		public static const totalDiffuseLightColor_ft_4:String = "totalDiffuseLightColor_ft_4";

		/** 总镜面反射颜色寄存器 */
		public static const totalSpecularLightColor_ft_4:String = "totalSpecularLightColor_ft_4";

		/** 光泽纹理寄存器 */
		public static const specularTexture_fs:String = "specularTexture_fs";

		/** 深度映射纹理(该纹理由片段着色器输出) */
		public static const depthMap_oc:String = "depthMap_oc";

		/** 深度映射纹理 */
		public static const depthMap_fs:String = "depthMap_fs";

		/** 深度映射矩阵 */
		public static const depthMap_vc_matrix:String = "depthMap_vc_matrix";

		/** 深度顶点常数0 (1.0, 255.0, 65025.0, 16581375.0) */
		public static const depthCommonData0_fc_vector:String = "depthCommonData0_fc_vector";

		/** 深度顶点常数1 (1.0/255.0, 1.0/255.0, 1.0/255.0, 0.0) */
		public static const depthCommonData1_fc_vector:String = "depthCommonData1_fc_vector";

		/** 投影后的顶点坐标 变量数据 */
		public static const positionProjected_v:String = "positionProjected_v";

		/** 深度映射uv坐标 变量数据 */
		public static const depthMapCoord_v:String = "depthMapCoord_v";

		/** 阴影函数顶点常数0 (0.5,-0.5,0,1) 用于深度值转换为uv值 */
		public static const shadowCommondata0_vc_vector:String = "shadowCommondata0_vc_vector";

		/** 阴影函数片段常数0 (1.0,1.0/255,1.0/255/255,1.0/255/255/255) 用于颜色值转换为深度值 */
		public static const shadowCommondata0_fc_vector:String = "shadowCommondata0_fc_vector";

		/** 阴影函数片段常数1 */
		public static const shadowCommondata1_fc_vector:String = "shadowCommondata1_fc_vector";

		/** 阴影函数片段常数2 保存有深度图尺寸 */
		public static const shadowCommondata2_fc_vector:String = "shadowCommondata2_fc_vector";

		/** 用于计算阴影相对于观察者距离不同而作衰减 */
		public static const secondary_fc_vector:String = "secondary_fc_vector";

		/** 阴影值临时变量寄存器 */
		public static const shadowValue_ft_4:String = "shadowValue_ft_4";

		/** 天空盒缩放静态数据 */
		public static const scaleSkybox_vc_vector:String = "scaleSkybox_vc_vector";

		/** 混合纹理 */
		public static const blendingtexture_fs:String = "blendingtexture_fs";

		/** 地形纹理数组 */
		public static const terrainTextures_fs_array:String = "terrainTextures_fs_array";

		/** 地形常量 */
		public static const tile_fc_vector:String = "tile_fc_vector";

		/** 粒子常数数据[0,1,2,0] */
		public static const particleCommon_vc_vector:String = "particleCommon_vc_vector";

		/** 广告牌旋转矩阵 */
		public static const particleBillboard_vc_matrix:String = "particleBillboard_vc_matrix";

		//--------------------------------
		//		缩放节点
		//--------------------------------
		/** 粒子缩放常数数据 */
		public static const particleScale_vc_vector:String = "particleScale_vc_vector";

		//--------------------------------
		//		时间节点
		//--------------------------------
		/** 粒子时间数据 */
		public static const particleTime_va_4:String = "particleTime_va_4";

		/** 粒子时间常量数据 */
		public static const particleTime_vc_vector:String = "particleTime_vc_vector";

		//--------------------------------
		//		速度节点
		//--------------------------------
		/** 粒子速度数据 */
		public static const particleVelocity_va_3:String = "particleVelocity_va_3";

		/** 粒子速度常数数据 */
		public static const particleVelocity_vc_vector:String = "particleVelocity_vc_vector";

		//--------------------------------
		//		颜色节点
		//--------------------------------
		/** 粒子颜色乘数因子起始值，用于计算粒子颜色乘数因子 */
		public static const particleStartColorMultiplier_vc_vector:String = "particleStartColorMultiplier_vc_vector";

		/** 粒子颜色乘数因子增量值，用于计算粒子颜色乘数因子 */
		public static const particleDeltaColorMultiplier_vc_vector:String = "particleDeltaColorMultiplier_vc_vector";

		/** 粒子颜色偏移起始值，用于计算粒子颜色偏移值 */
		public static const particleStartColorOffset_vc_vector:String = "particleStartColorOffset_vc_vector";

		/** 粒子颜色偏移增量值，用于计算粒子颜色偏移值 */
		public static const particleDeltaColorOffset_vc_vector:String = "particleDeltaColorOffset_vc_vector";

		/** 粒子颜色乘数因子，用于乘以纹理上的颜色值 */
		public static const particleColorMultiplier_v:String = "particleColorMultiplier_v";

		/** 粒子颜色乘数因子，用于乘以纹理上的颜色值 */
		public static const particleColorOffset_v:String = "particleColorOffset_v";

		/** 线段起点坐标数据 */
		public static const segmentStart_va_3:String = "segmentStart_va_3";

		/** 线段终点坐标数据 */
		public static const segmentEnd_va_3:String = "segmentEnd_va_3";

		/** 线段厚度数据 */
		public static const segmentThickness_va_1:String = "segmentThickness_va_1";

		/** 线段颜色数据 */
		public static const segmentColor_va_4:String = "segmentColor_va_4";

		/** 摄像机坐标系到投影坐标系变换矩阵静态数据 */
		public static const segmentC2pMatrix_vc_matrix:String = "segmentC2pMatrix_vc_matrix";

		/** 模型坐标系到摄像机坐标系变换矩阵静态数据 */
		public static const segmentM2cMatrix_vc_matrix:String = "segmentM2cMatrix_vc_matrix";

		/** 常数1 */
		public static const segmentOne_vc_vector:String = "segmentOne_vc_vector";
		/** 常数前向量 */
		public static const segmentFront_vc_vector:String = "segmentFront_vc_vector";
		/** 常量数据 */
		public static const segmentConstants_vc_vector:String = "segmentConstants_vc_vector";

		/** 临时镜面反射纹理数据 */
		public static const specularTexData_ft_4:String = "specularTexData_ft_4";

		/** 临时法线纹理数据 */
		public static const normalTexData_ft_4:String = "normalTexData_ft_4";
	}
}

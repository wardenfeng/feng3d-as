package me.feng3d.configs
{



	/**
	 * 3D缓冲编号配置
	 * @author warden_feng 2015-7-21
	 */
	public class Context3DBufferIDConfig
	{
		public static const bufferIdConfigs:Array = [ //
			//----------------------------------------------------------
			["normal_va_3", "法线数据"], //
			["tangent_va_3", "切线数据"], //
			["camerapos_vc_vector", " 摄像机位置静态数据 "], //
			["sceneTransform_vc_matrix", " 场景变换矩阵(模型空间转场景空间) "], //
			["normalSceneTransform_vc_matrix", " 法线场景变换矩阵(模型空间转场景空间) "], //
			["wordProjection_vc_matrix", " 世界投影矩阵(世界坐标转context3D的2D坐标) "], //
			["normal_ft_4", " 法线临时片段寄存器 "], //
			["globalPosition_vt_4", " 顶点世界坐标 "], //
			["cameraPosition_vc_vector", " 摄像机世界坐标 "], //
			["normal_v", " 法线变量寄存器 "], //
			["tangent_v", " 切线变量寄存器 "], //
			["bitangent_v", " 双切线变量寄存器 "], //
			["viewDir_v", " 视线变量寄存器 "], //
			["globalPos_v", " 世界坐标变量 "], //
			["viewDir_ft_4", " 视线方向片段临时数据 "], //
			["tangent_ft_4", " 切线片段临时寄存器 "], //
			["biTangent_ft_4", " 双切线片段临时寄存器 "], //
			["normalTexture_fs", " 法线纹理寄存器 "], //
			["normalTexData_ft_4", " 法线纹理数据临时寄存器 "], //
			["specularTexData_ft_4", " 光泽纹理数据片段临时寄存器 "], //
			["finalColor_ft_4", " 最终颜色寄存器（输出到oc寄存器的颜色） "], //
			//---------------------------- 常用寄存器数据类型 ------------------------------
			["index", "索引数据"], //
			["position_va_3", "顶点坐标数据"], //
			["color_va_3", "顶点颜色数据"], //
			["color_v", "颜色变量寄存器"], //
			["uv_va_2", "uv数据"], //
			["projection_vc_matrix", "顶点程序投影矩阵静态数据"], //
			["uv_v", "uv变量数据"], //
			["texture_fs", "片段程序的纹理"], //
			["color_fc_vector", "颜色静态数据"], //
			["program", "渲染程序"], //
			["culling", "三角形剔除模式"], //
			["blendFactors", "颜色混合"], //
			["depthTest", "深度测试模式"], //
			["commonsData_fc_vector", "公用数据片段常量数据"], //
			["_op", "顶点输出寄存器"], //
			["_oc", "片段输出寄存器"], //
			//---------------------------- 常用寄存器数据类型 ------------------------------
			["animated_va_3", "骨骼动画计算完成后的顶点坐标数据"], //
			["position0_va_3", "顶点动画第0个坐标数据"], //
			["position1_va_3", "顶点动画第1个坐标数据"], //
			["animatedPosition_vt_4", "动画后的顶点坐标数据"], //
			["jointindex_va_x", "关节索引数据"], //
			["jointweights_va_x", "关节权重数据"], //
			["weights_vc_vector", "顶点程序权重向量静态数据"], //
			["globalmatrices_vc_vector", "骨骼全局变换矩阵静态数据"], //
			//---------------------------- 灯光相关寄存器数据类型 ------------------------------
			["ambientInput_fc_vector", "环境输入静态数据"], //
			["diffuseInput_fc_vector", "漫射输入静态数据"], //
			["dirLightSceneDir_fc_vector", "方向光源场景方向"], //
			["dirLightDiffuse_fc_vector", "方向光源漫反射光颜色"], //
			["dirLightSpecular_fc_vector", "方向光源镜面反射颜色"], //
			["pointLightScenePos_fc_vector", "点光源场景位置"], //
			["pointLightDiffuse_fc_vector", "点光源漫反射光颜色"], //
			["pointLightSpecular_fc_vector", "点光源镜面反射颜色"], //
			["specularData_fc_vector", "材质镜面反射光数据"], //
			["specularColor_ft_4", "镜面反射光临时片段寄存器"], //
			["mDiff_ft", "材质的漫反射颜色"], //
			["ambient_ft", "环境光因子临时变量"], //
			["totalDiffuseLightColor_ft_4", "总漫反射颜色寄存器"], //
			["totalSpecularLightColor_ft_4", "总镜面反射颜色寄存器"], //
			["specularTexture_fs", "光泽纹理寄存器"], //
			//---------------------------- 阴影相关寄存器数据类型 ------------------------------
			["depthMap_oc", "深度映射纹理(该纹理由片段着色器输出)"], //
			["depthMap_fs", "深度映射纹理"], //
			["depthMap_vc_matrix", "深度映射矩阵"], //
			["depthCommonData0_fc_vector", "深度顶点常数0 (1.0, 255.0, 65025.0, 16581375.0)"], //
			["depthCommonData1_fc_vector", "深度顶点常数1 (1.0/255.0, 1.0/255.0, 1.0/255.0, 0.0)"], //
			["positionProjected_v", "投影后的顶点坐标 变量数据"], //
			["depthMapCoord_v", "深度映射uv坐标 变量数据"], //
			["shadowCommondata0_vc_vector", "阴影函数顶点常数0 (0.5,-0.5,0,1) 用于深度值转换为uv值"], //
			["shadowCommondata0_fc_vector", "阴影函数片段常数0 (1.0,1.0/255,1.0/255/255,1.0/255/255/255) 用于颜色值转换为深度值"], //
			["shadowCommondata1_fc_vector", "阴影函数片段常数1"], //
			["shadowCommondata2_fc_vector", "阴影函数片段常数2 保存有深度图尺寸"], //
			["secondary_fc_vector", "用于计算阴影相对于观察者距离不同而作衰减"], //
			["shadowValue_ft_4", "阴影值临时变量寄存器"], //
			//---------------------------- 天空盒相关寄存器数据类型 ------------------------------
			["scaleSkybox_vc_vector", "天空盒缩放静态数据"], //
			//---------------------------- 地形相关寄存器数据类型 ------------------------------
			["blendingtexture_fs", "混合纹理"], //
			["terrainTextures_fs_array", "地形纹理数组"], //
			["tile_fc_vector", "地形常量"], //
			//---------------------------- 粒子相关寄存器数据类型 ------------------------------
			["particleCommon_vc_vector", "粒子常数数据[0,1,2,0]"], //
			["particleBillboard_vc_matrix", "广告牌旋转矩阵"], //
			["particleScale_vc_vector", "粒子缩放常数数据"], //
			["particleTime_va_4", "粒子时间数据"], //
			["particleTime_vc_vector", "粒子时间常量数据"], //
			["particleVelocity_va_3", "粒子速度数据"], //
			["particleVelocity_vc_vector", "粒子速度常数数据"], //
			["particleStartColorMultiplier_vc_vector", "粒子颜色乘数因子起始值，用于计算粒子颜色乘数因子"], //
			["particleDeltaColorMultiplier_vc_vector", "粒子颜色乘数因子增量值，用于计算粒子颜色乘数因子"], //
			["particleStartColorOffset_vc_vector", "粒子颜色偏移起始值，用于计算粒子颜色偏移值"], //
			["particleDeltaColorOffset_vc_vector", "粒子颜色偏移增量值，用于计算粒子颜色偏移值"], //
			["particleColorMultiplier_v", "粒子颜色乘数因子，用于乘以纹理上的颜色值"], //
			["particleColorOffset_v", "粒子颜色乘数因子，用于乘以纹理上的颜色值"], //
			["particlePositionTemp_vt_4", "粒子顶点坐标数据"], //
			["particleColorOffset_vt_4", "粒子颜色偏移值，在片段渲染的最终颜色值上偏移"], //
			["particleColorMultiplier_vt_4", "粒子颜色乘数因子，用于乘以纹理上的颜色值"], //

			["inCycleTime_vt_4", "粒子周期内时间临时寄存器"], //

			//---------------------------- 线段相关寄存器数据类型 ------------------------------
			["segmentStart_va_3", "线段起点坐标数据"], //
			["segmentEnd_va_3", "线段终点坐标数据"], //
			["segmentThickness_va_1", "线段厚度数据"], //
			["segmentColor_va_4", "线段颜色数据"], //
			["segmentC2pMatrix_vc_matrix", "摄像机坐标系到投影坐标系变换矩阵静态数据"], //
			["segmentM2cMatrix_vc_matrix", "模型坐标系到摄像机坐标系变换矩阵静态数据"], //
			["segmentOne_vc_vector", "常数1"], //
			["segmentFront_vc_vector", "常数前向量"], //
			["segmentConstants_vc_vector", "常量数据"], //
			];
	}
}

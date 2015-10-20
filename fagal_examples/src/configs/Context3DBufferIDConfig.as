package configs
{

	/**
	 * 缓冲编号配置文件
	 * @author warden_feng 2015-7-23
	 */
	public class Context3DBufferIDConfig
	{
		public static const bufferIdConfigs:Array = [ //
			["index", "索引数据"], //
			["program", "渲染程序"], //
			["position_va_3", "顶点坐标数据"], //
			["color_va_3", "顶点颜色数据"], //
			["projection_vc_matrix", "顶点程序投影矩阵静态数据"], //
			["color_v", "颜色变量寄存器"], //
			["_op", "顶点输出寄存器"], //
			["_oc", "片段输出寄存器"], //
			//------------------------
			//		地形渲染相关
			//------------------------
			["terrainTextures_fs_array", "地形纹理数组"], //
			["uv_va_2", "uv数据"], //
			["uv_v", "uv变量数据"], //
			//------------------------
			//		地形渲染相关
			//------------------------
			["commonsData_vc_vector", "公用数据片段常量数据"], //
			];
	}
}

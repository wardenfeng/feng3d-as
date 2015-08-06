package me.feng3d.fagal.vertex.shadowMap
{
	import me.feng3d.core.register.Register;
	
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 方向光阴影映射
	 * @author warden_feng 2015-7-17
	 */
	public function V_ShadowMapPlanar():void
	{
		var _:* = FagalRE.instance.space;

		var temp:Register = _.getFreeTemp();

		//计算顶点深度值
		_.m44(temp, _.globalPosition_vt_4, _.depthMap_vc_matrix);
		//计算顶点深度值(x,y计算深度图中的uv，z计算深度)
		_.div(temp, temp, temp.w);
		//x,y计算深度图中的uv
		_.mul(temp.xy, temp.xy, _.shadowCommondata0_vc_vector.xy);
		//计算深度图坐标
		_.add(_.depthMapCoord_v, temp, _.shadowCommondata0_vc_vector.xxwz);
	}
}

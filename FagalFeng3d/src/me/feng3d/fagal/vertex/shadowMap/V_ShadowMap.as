package me.feng3d.fagal.vertex.shadowMap
{
	import me.feng3d.fagal.methods.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsShadowMap;

	/**
	 * 编译阴影映射顶点程序
	 * @author warden_feng 2015-6-23
	 */
	public function V_ShadowMap():void
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var shaderParamsShadowMap:ShaderParamsShadowMap = shaderParams.getComponent(ShaderParamsShadowMap.NAME);

		shaderParamsShadowMap.usePoint ? V_ShadowMapPoint() : V_ShadowMapPlanar();
	}
}

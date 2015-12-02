package me.feng3d.fagal.vertex.shadowMap
{
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShadowShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 编译阴影映射顶点程序
	 * @author feng 2015-6-23
	 */
	public function V_ShadowMap():void
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		var shadowShaderParams:ShadowShaderParams = shaderParams.getComponent(ShadowShaderParams.NAME);

		shadowShaderParams.usePoint > 0 ? V_ShadowMapPoint() : V_ShadowMapPlanar();
	}
}

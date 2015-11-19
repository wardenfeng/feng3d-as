package me.feng3d.fagal.vertex.shadowMap
{
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;

	/**
	 * 编译阴影映射顶点程序
	 * @author feng 2015-6-23
	 */
	public function V_ShadowMap():void
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;

		shaderParams.usePoint > 0 ? V_ShadowMapPoint() : V_ShadowMapPlanar();
	}
}

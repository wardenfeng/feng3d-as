package me.feng3d.fagal.fragment.particle
{
	import me.feng3d.fagalRE.FagalRE;
	import me.feng3d.fagal.params.ShaderParams;

	/**
	 * 粒子片段渲染程序
	 * @author feng 2015-1-21
	 */
	public function F_Particles():void
	{
		var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;
		/** 粒子渲染参数 */
		if (shaderParams.ParticleColorGlobal)
		{
			F_ParticleColorCombination();
		}

	}
}

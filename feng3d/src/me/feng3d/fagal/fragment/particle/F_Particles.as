package me.feng3d.fagal.fragment.particle
{
	import me.feng3d.fagal.methods.FagalFragmentMethod;
	import me.feng3d.fagal.params.ParticleShaderParam;

	/**
	 * 粒子片段渲染程序
	 * @author warden_feng 2015-1-21
	 */
	public class F_Particles extends FagalFragmentMethod
	{
		/**
		 * 粒子渲染参数
		 */
		public function get particleShaderParam():ParticleShaderParam
		{
			return shaderParams.particleShaderParam;
		}

		override public function runFunc():void
		{
			particleShaderParam.ParticleColorGlobal && call(F_ParticleColorCombination);
		}

	}
}

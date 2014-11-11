package me.feng3d.fagal.fragment
{
	import me.feng3d.fagal.methods.FagalMethod;
	
	/**
	 * 基本漫反射函数
	 * @author warden_feng 2014-11-5
	 */
	[FagalMethod(methodType="fragment")]
	public class F_BasicDiffuse extends FagalMethod
	{
		override public function runFunc():void
		{
			shaderParams;
			if(shaderParams.hasDiffuseTexture)
				call(F_DiffuseTexure);
			else
				call(F_DiffuseColor);
		}
	}
}
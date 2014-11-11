package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 漫反射材质颜色
	 * @author warden_feng 2014-11-6
	 */
	[FagalMethod(methodType = "fragment")]
	public class F_DiffuseColor extends FagalMethod
	{
		[Register(regName = "diffuseInput_fc_vector", regType = "in", description = "漫射输入静态数据")]
		public var _diffuseInputRegister:Register;

		[Register(regName = "Mdiff_ft", regType = "out", description = "材质的漫反射颜色")]
		public var mdiffReg:Register;

		override public function runFunc():void
		{
			//漫射输入静态数据 
			mov(mdiffReg, _diffuseInputRegister);
		}
	}
}

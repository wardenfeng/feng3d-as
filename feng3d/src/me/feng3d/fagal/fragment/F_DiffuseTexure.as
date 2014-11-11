package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 漫反射纹理取样
	 * @author warden_feng 2014-11-6
	 */
	[FagalMethod(methodType = "fragment")]
	public class F_DiffuseTexure extends FagalMethod
	{
		[Register(regName = "texture_fs", regType = "in", description = "片段程序的纹理")]
		public var _diffuseInputRegister:Register;

		[Register(regName = "uv_v", regType = "in", description = "uv变量数据")]
		public var uvReg:Register;

		[Register(regName = "Mdiff_ft", regType = "out", description = "材质的漫反射颜色")]
		public var mdiffReg:Register;

		override public function runFunc():void
		{
			tex(mdiffReg, uvReg, _diffuseInputRegister);
		}
	}
}

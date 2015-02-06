package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalFragmentMethod;

	/**
	 * 光泽图取样函数
	 * @author warden_feng 2014-10-23
	 */
	public class F_SpecularSample extends FagalFragmentMethod
	{
		[Register(regName = "specularTexture_fs", regType = "in", description = "光泽纹理寄存器")]
		public var specularFragmentReg:Register;

		[Register(regName = "uv_v", regType = "in", description = "uv变量数据")]
		public var uv:Register;

		[Register(regName = "specularTexData_ft_4", regType = "out", description = "光泽纹理数据片段临时寄存器")]
		public var specularTexData:Register;

		override public function runFunc():void
		{
			//获取纹理数据
			tex(specularTexData, uv, specularFragmentReg);
		}
	}
}

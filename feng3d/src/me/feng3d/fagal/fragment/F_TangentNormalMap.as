package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 编译切线法线贴图片段程序
	 * @author warden_feng 2014-11-7
	 */
	[FagalMethod(methodType = "fragment")]
	public class F_TangentNormalMap extends FagalMethod
	{
		[Register(regName = "tangent_v", regType = "in", description = "切线变量寄存器")]
		public var tangentVarying:Register;

		[Register(regName = "bitangent_v", regType = "in", description = "双切线变量寄存器")]
		public var bitangentVarying:Register;

		[Register(regName = "normal_v", regType = "in", description = "法线变量寄存器")]
		public var normalVarying:Register;

		[Register(regName = "normalTexData_ft_4", regType = "in", description = "法线纹理数据片段临时寄存器")]
		public var normalTexData:Register;

		[Register(regName = "normal_ft_4", regType = "out", description = "法线临时片段寄存器")]
		public var normalFragment:Register;

		override public function runFunc():void
		{
			var t:Register = getFreeTemp("切线片段临时寄存器");
			var b:Register = getFreeTemp("双切线片段临时寄存器");
			var n:Register = getFreeTemp("法线片段临时寄存器");

			//标准化切线
			nrm(t.xyz, tangentVarying);
			//保存w不变
			mov(t.w, tangentVarying.w);
			//标准化双切线
			nrm(b.xyz, bitangentVarying);
			//标准化法线
			nrm(n.xyz, normalVarying);

			call(F_NormalSample);

			//标准化法线纹理数据
			m33(normalFragment.xyz, normalTexData, t);
			//保存w不变
			mov(normalFragment.w, normalVarying.w);
			
			removeTemp(normalTexData);
		}

	}
}

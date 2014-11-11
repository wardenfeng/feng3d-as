package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 基本颜色输出渲染程序
	 * @author warden_feng 2014-10-30
	 */
	[FagalMethod(methodType = "fragment")]
	public class F_BaseOut extends FagalMethod
	{
		[Register(regName = "texture_fs", regType = "in", description = "片段程序的纹理")]
		public var texture:Register;

		[Register(regName = "uv_v", regType = "in", description = "uv变量数据")]
		public var uv_v:Register;

		[Register(regName = "oc", regType = "out", description = "颜色输出寄存器")]
		public var out:Register;

		override public function runFunc():void
		{
			//获取纹理数据
			tex(out, uv_v, texture);
		}
	}
}

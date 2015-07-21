package fagal
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 输出颜色贴图
	 * @author warden_feng 2014-10-24
	 */
	public class F_colorMap extends FagalMethod
	{
		public function F_colorMap()
		{
			_shaderType = Context3DProgramType.FRAGMENT;
		}

		override public function runFunc():void
		{
			//颜色变量寄存器 (此处用作为混合值)
			var color_v:Register = requestRegister(Context3DBufferTypeID.COLOR_V);
			//颜色输出寄存器
			var out:Register = requestRegister(Context3DBufferTypeID.OC);
			//
			mov(out, color_v);
		}
	}
}



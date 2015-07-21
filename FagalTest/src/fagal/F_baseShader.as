package fagal
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 基础片段渲染
	 * @author warden_feng 2014-10-24
	 */
	public class F_baseShader extends FagalMethod
	{
		public function F_baseShader()
		{
			_shaderType = Context3DProgramType.FRAGMENT;
		}

		override public function runFunc():void
		{
			//颜色变量寄存器
			var color_v:Register = requestRegister(Context3DBufferTypeID.COLOR_V);

			//颜色输出寄存器
			var out:Register = requestRegister(Context3DBufferTypeID.OC);

			comment("传递顶点颜色数据" + color_v + "到片段寄存器" + out);
			mov(out, color_v);
		}
	}
}



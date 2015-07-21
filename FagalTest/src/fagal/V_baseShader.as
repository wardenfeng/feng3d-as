package fagal
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterMatrix;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.requestRegisterMatrix;
	import me.feng3d.fagal.base.operation.m44;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 基础顶点渲染
	 * @author warden_feng 2014-10-24
	 */
	public class V_baseShader extends FagalMethod
	{
		public function V_baseShader()
		{
			_shaderType = Context3DProgramType.VERTEX;
		}

		override public function runFunc():void
		{
			//顶点坐标数据
			var position:Register = requestRegister(Context3DBufferTypeID.POSITION_VA_3);
			//顶点颜色数据
			var color:Register = requestRegister(Context3DBufferTypeID.COLOR_VA_3);
			//颜色变量寄存器
			var color_v:Register = requestRegister(Context3DBufferTypeID.COLOR_V);
			//顶点程序投影矩阵静态数据
			var projection:RegisterMatrix = requestRegisterMatrix(Context3DBufferTypeID.PROJECTION_VC_MATRIX);
			//位置输出寄存器
			var out:Register = requestRegister(Context3DBufferTypeID.OP);

			comment("应用投影矩阵" + projection + "使世界坐标" + position + "转换为投影坐标 并输出到顶点寄存器" + out + "");
			m44(out, position, projection);

			comment("传递顶点颜色数据" + color + "到变量寄存器" + color_v);
			mov(color_v, color);
		}
	}
}



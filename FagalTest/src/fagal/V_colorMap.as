package fagal
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.mul;
	import me.feng3d.fagal.base.operation.sub;
	import me.feng3d.fagal.methods.FagalMethod;

	/**
	 * 输出颜色贴图
	 * @author warden_feng 2014-10-24
	 */
	public class V_colorMap extends FagalMethod
	{
		public function V_colorMap()
		{
			_shaderType = Context3DProgramType.VERTEX;
		}

		override public function runFunc():void
		{
			//顶点颜色数据
			var color:Register = requestRegister(Context3DBufferTypeID.COLOR_VA_3);
			//uv数据
			var uv:Register = requestRegister(Context3DBufferTypeID.UV_VA_2);

			//颜色变量寄存器
			var color_v:Register = requestRegister(Context3DBufferTypeID.COLOR_V);
			//位置输出寄存器
			var out:Register = requestRegister(Context3DBufferTypeID.OP);

			//公用数据片段常量数据
			var commonsReg:Register = requestRegister(Context3DBufferTypeID.COMMONSDATA_VC_VECTOR);

			comment("传递顶点颜色数据" + color + "到变量寄存器" + color_v);
			mov(color_v, color);

			var uvTemp:Register = getFreeTemp("临时uv数据");
			mov(uvTemp, uv);
			mul(uvTemp.xy, uvTemp.xy, commonsReg.x);
			sub(uvTemp.xy, uvTemp.xy, commonsReg.yy);

			//把uv 作为坐标输出
			mov(out, uvTemp);
		}
	}
}



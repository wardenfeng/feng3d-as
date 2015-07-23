package fagal
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagalRE.FagalRE;

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
			var _:* = FagalRE.instance.space;

			//公用数据片段常量数据
			_.comment("传递顶点颜色数据", _.color_va_3, "到变量寄存器", _.color_v);
			_.mov(_.color_v, _.color_va_3);

			var uvTemp:Register = getFreeTemp("临时uv数据");
			_.mov(uvTemp, _.uv_va_2);
			_.mul(uvTemp.xy, uvTemp.xy, _.commonsData_vc_vector.x);
			_.sub(uvTemp.xy, uvTemp.xy, _.commonsData_vc_vector.yy);

			//把uv 作为坐标输出
			_.mov(_._op, uvTemp);
		}
	}
}



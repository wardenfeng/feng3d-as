package fagal
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 顶点颜色渲染地形 顶点渲染
	 * @author warden_feng 2014-10-24
	 */
	public class V_colorTerrain extends FagalMethod
	{
		public function V_colorTerrain()
		{
			_shaderType = Context3DProgramType.VERTEX;
		}

		override public function runFunc():void
		{
			var _:* = FagalRE.instance.space;

			_.comment("应用投影矩阵", _.projection_vc_matrix, "使世界坐标", _.position_va_3, "转换为投影坐标 并输出到顶点寄存器", _._op);
			_.m44(_._op, _.position_va_3, _.projection_vc_matrix);

			_.comment("传递顶点颜色数据", _.color_va_3, "到变量寄存器", _.color_v);
			_.mov(_.color_v, _.color_va_3);

			_.comment("传递顶点uv数据", _.uv_va_2, "到变量寄存器", _.uv_v);
			_.mov(_.uv_v, _.uv_va_2);
		}
	}
}



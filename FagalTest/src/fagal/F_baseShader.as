package fagal
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagalRE.FagalRE;

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
			var _:* = FagalRE.instance.space;

			_.comment("传递顶点颜色数据", _._oc, "到片段寄存器", _.color_v);
			_.mov(_._oc, _.color_v);
		}
	}
}



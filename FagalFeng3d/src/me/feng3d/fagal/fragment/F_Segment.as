package me.feng3d.fagal.fragment
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 线段片段渲染程序
	 * @author feng 2014-10-28
	 */
	public class F_Segment extends FagalMethod
	{
		public function F_Segment()
		{
			_shaderType = Context3DProgramType.FRAGMENT;
		}

		override public function runFunc():void
		{
			var _:* = FagalRE.instance.space;

			_.comment("传递顶点颜色数据" + _.color_v + "到片段寄存器" + _._oc);
			_.mov(_._oc, _.color_v);
		}
	}
}



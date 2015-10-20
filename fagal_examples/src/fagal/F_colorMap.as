package fagal
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagalRE.FagalRE;

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
			var _:* = FagalRE.instance.space;

			//颜色输出
			_.mov(_._oc, _.color_v);
		}
	}
}



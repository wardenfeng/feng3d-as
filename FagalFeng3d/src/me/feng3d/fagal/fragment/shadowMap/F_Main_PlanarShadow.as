package me.feng3d.fagal.fragment.shadowMap
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 深度图片段主程序
	 * @author warden_feng 2015-5-30
	 */
	public class F_Main_PlanarShadow extends FagalMethod
	{
		/**
		 * 创建深度图片段主程序
		 */
		public function F_Main_PlanarShadow()
		{
			_shaderType = Context3DProgramType.FRAGMENT;
		}

		/**
		 * @inheritDoc
		 */
		override public function runFunc():void
		{
			var _:* = FagalRE.instance.space;

			_.mov(_._oc, _.shadowColorCommonsData_fc_vector);
		}
	}
}

package me.feng3d.fagal.fragment
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 天空盒片段渲染程序
	 * @author warden_feng 2014-11-4
	 */
	public class F_SkyBox extends FagalMethod
	{
		public function F_SkyBox()
		{
			_shaderType = Context3DProgramType.FRAGMENT;
		}

		override public function runFunc():void
		{
			var _:* = FagalRE.instance.space;

			//获取纹理数据
			_.tex(_._oc, _.uv_v, _.texture_fs);
		}
	}
}

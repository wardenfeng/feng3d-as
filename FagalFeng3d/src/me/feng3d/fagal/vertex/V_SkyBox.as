package me.feng3d.fagal.vertex
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.methods.FagalMethod;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 天空盒顶点渲染程序
	 * @author warden_feng 2014-11-4
	 */
	public class V_SkyBox extends FagalMethod
	{
		public function V_SkyBox()
		{
			_shaderType = Context3DProgramType.VERTEX;
		}

		override public function runFunc():void
		{
			var _:* = FagalRE.instance.space;

			var vt0:Register = getFreeTemp("缩放后的顶点坐标");
			_.comment("缩放到天空盒应有的大小");
			_.mul(vt0, _.position_va_3, _.scaleSkybox_vc_vector);
			_.comment("把天空盒中心放到摄像机位置");
			_.add(vt0, vt0, _.camerapos_vc_vector);
			_.comment("投影天空盒坐标");
			_.m44(_._op, vt0, _.projection_vc_matrix)
			_.comment("占坑用的，猜的");
			_.mov(_.uv_v, _.position_va_3);
		}
	}
}



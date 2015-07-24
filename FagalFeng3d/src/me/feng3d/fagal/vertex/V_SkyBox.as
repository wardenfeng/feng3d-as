package me.feng3d.fagal.vertex
{
	import flash.display3D.Context3DProgramType;

	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.operation.add;
	import me.feng3d.fagal.base.operation.m44;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.mul;
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
			comment("缩放到天空盒应有的大小");
			mul(vt0, _.position_va_3, _.scaleSkybox_vc_vector);
			comment("把天空盒中心放到摄像机位置");
			add(vt0, vt0, _.camerapos_vc_vector);
			comment("投影天空盒坐标");
			m44(_._op, vt0, _.projection_vc_matrix)
			comment("占坑用的，猜的");
			mov(_.uv_v, _.position_va_3);
		}
	}
}



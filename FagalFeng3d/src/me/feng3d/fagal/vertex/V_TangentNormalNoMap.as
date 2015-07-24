package me.feng3d.fagal.vertex
{
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.operation.m33;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 编译切线顶点程序(无法线图)
	 * @author warden_feng 2014-11-7
	 */
	public function V_TangentNormalNoMap():void
	{
		var _:* = FagalRE.instance.space;

		comment("转换法线到全局");
		m33(_.normal_v.xyz, _.normal_va_3, _.normalSceneTransform_vc_matrix);
		//保存w不变
		mov(_.normal_v.w, _.normal_va_3.w);
	}

}

package me.feng3d.fagal.vertex
{
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.operation.m44;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 顶点世界坐标渲染函数
	 * @author warden_feng 2014-11-7
	 */
	public function V_WorldPosition():void
	{
		var _:* = FagalRE.instance.space;

		comment("场景坐标转换");
		m44(_.globalPosition_vt_4, _.position_va_3, _.sceneTransform_vc_matrix);
	}
}

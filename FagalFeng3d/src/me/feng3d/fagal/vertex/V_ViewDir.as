package me.feng3d.fagal.vertex
{
	import me.feng3d.fagal.base.comment;
	import me.feng3d.fagal.base.operation.sub;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 视线顶点渲染函数
	 * @author warden_feng 2014-11-7
	 */
	public function V_ViewDir():void
	{
		var _:* = FagalRE.instance.space;

		comment("计算视线方向");
		sub(_.viewDir_v, _.cameraPosition_vc_vector, _.globalPosition_vt_4);

	}
}

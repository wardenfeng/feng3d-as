package me.feng3d.fagal.vertex
{
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 视线顶点渲染函数
	 * @author feng 2014-11-7
	 */
	public function V_ViewDir():void
	{
		var _:* = FagalRE.instance.space;

		_.comment("计算视线方向");
		_.sub(_.viewDir_v, _.cameraPosition_vc_vector, _.globalPosition_vt_4);
	}
}

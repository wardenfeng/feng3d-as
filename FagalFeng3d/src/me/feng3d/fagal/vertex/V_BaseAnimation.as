package me.feng3d.fagal.vertex
{
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 基础动画顶点渲染函数(无动画)
	 * @author warden_feng 2014-11-3
	 */
	public function V_BaseAnimation():void
	{
		var _:* = FagalRE.instance.space;

		_.mov(_.animatedPosition_vt_4, _.position_va_3);
	}
}

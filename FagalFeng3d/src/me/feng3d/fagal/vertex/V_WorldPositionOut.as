package me.feng3d.fagal.vertex
{

	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 世界坐标输出函数
	 * @author warden_feng 2014-11-7
	 */
	public function V_WorldPositionOut():void
	{
		var _:* = FagalRE.instance.space;

		_.mov(_.globalPos_v, _.globalPosition_vt_4);
	}
}

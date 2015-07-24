package me.feng3d.fagal.fragment.light
{

	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 环境光片段渲染程序
	 * @author warden_feng 2014-11-7
	 */
	public function F_Ambient():void
	{
		var _:* = FagalRE.instance.space;

		_.mov(_.ambient_ft, _.ambientInput_fc_vector);
	}
}

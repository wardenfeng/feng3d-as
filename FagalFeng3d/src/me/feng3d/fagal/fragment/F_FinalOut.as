package me.feng3d.fagal.fragment
{
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 最终颜色输出函数
	 * @author warden_feng 2014-11-7
	 */
	public function F_FinalOut():void
	{
		var _:* = FagalRE.instance.space;

		_.mov(_._oc, _.finalColor_ft_4);
	}
}

package me.feng3d.fagal.fragment
{
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 编译切线片段程序(无法线图)
	 * @author warden_feng 2014-11-7
	 */
	public function F_TangentNormalNoMap():void
	{
		var _:* = FagalRE.instance.space;

		//标准化法线
		_.nrm(_.normal_ft_4.xyz, _.normal_v);
		//保存w不变
		_.mov(_.normal_ft_4.w, _.normal_v.w);

	}
}

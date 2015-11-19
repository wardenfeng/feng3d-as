package me.feng3d.fagal.fragment
{
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 视线片段渲染函数
	 * @author feng 2014-11-7
	 */
	public function F_ViewDir():void
	{
		var _:* = FagalRE.instance.space;

		//标准化视线
		_.nrm(_.viewDir_ft_4.xyz, _.viewDir_v);
		//保持w不变
		_.mov(_.viewDir_ft_4.w, _.viewDir_v.w);
	}
}

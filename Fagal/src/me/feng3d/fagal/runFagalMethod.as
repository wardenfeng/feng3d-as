package me.feng3d.fagal
{
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * 运行Fagal函数
	 * @author warden_feng 2014-10-31
	 */
	public function runFagalMethod(agalMethod:*):String
	{
		return FagalRE.instance.run(agalMethod);
	}
}

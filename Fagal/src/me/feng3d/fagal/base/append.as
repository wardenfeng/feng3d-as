package me.feng3d.fagal.base
{
	import me.feng3d.arcanefagal;
	import me.feng3d.fagalRE.FagalRE;

	use namespace arcanefagal;

	/**
	 * 添加代码
	 * @author warden_feng 2015-4-24
	 */
	public function append(code:String):void
	{
		FagalRE.instance.append(code);
	}
}



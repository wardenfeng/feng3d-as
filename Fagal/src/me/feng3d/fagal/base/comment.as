package me.feng3d.fagal.base
{
	import me.feng3d.fagal.FagalToken;
	import me.feng3d.debug.Debug;
	
	/**
	 * 添加注释
	 * @author warden_feng 2015-4-24
	 */
	public function comment(... remarks):void
	{
		if (!Debug.agalDebug)
			return;
		for (var i:int = 0; i < remarks.length; i++)
		{
			append(FagalToken.COMMENT + remarks[i]);
		}
	}
}
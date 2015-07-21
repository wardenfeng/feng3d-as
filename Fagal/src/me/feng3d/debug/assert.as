package me.feng3d.debug
{

	/**
	 * 断言
	 * @author warden_feng 2014-10-29
	 */
	public function assert(b:Boolean, msg:String = "assert"):void
	{
		if (!b)
			throw new Error(msg);
	}
}

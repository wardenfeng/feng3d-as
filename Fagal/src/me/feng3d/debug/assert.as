package me.feng3d.debug
{

	/**
	 * 断言
	 * @b			判定为真的表达式
	 * @msg			在表达式为假时将输出的错误信息
	 * @author warden_feng 2014-10-29
	 */
	public function assert(b:Boolean, msg:String = "assert"):void
	{
		if (!b)
			throw new Error(msg);
	}
}

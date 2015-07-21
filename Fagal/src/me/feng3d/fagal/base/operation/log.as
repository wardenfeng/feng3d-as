package me.feng3d.fagal.base.operation
{
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.base.append;

	/**
	 * destination=log(source1)一个寄存器以2为底的对数，分量形式
	 * @author warden_feng 2014-10-22
	 */
	public function log(destination:IField, source1:IField):void
	{
		var code:String="log " + destination + ", " + source1;
		append(code);
	}
}


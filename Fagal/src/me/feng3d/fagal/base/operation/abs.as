package me.feng3d.fagal.base.operation
{
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.base.append;

	/**
	 * destination=abs(source1):一个寄存器的绝对值，分量形式
	 * @author warden_feng 2014-10-22
	 */
	public function abs(destination:IField, source1:IField):void
	{
		var code:String = "abs " + destination + ", " + source1;
		append(code);
	}
}


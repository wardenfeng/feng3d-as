package me.feng3d.fagal.base.operation
{
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.base.append;

	/**
	 * destination=-source1:一个寄存器取反，分量形式
	 * @author warden_feng 2014-10-22
	 */
	public function neg(destination:IField, source1:IField):void
	{
		var code:String = "neg " + destination + ", " + source1;
		append(code);
	}
}

